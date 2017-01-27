class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.14/gearmand-1.1.14.tar.gz"
  sha256 "6e01b72cdf386149f689cccd934e79c55851549845f0128683a726ffb3200cd0"
  revision 1

  bottle do
    sha256 "33da528d8425788f8ef1ffa6644dbec84c4f8a4f90ba37275ff810e8bb1ea6d6" => :sierra
    sha256 "fa86de8753c421bdd4f4e73d40eaf65077bf2b65448d2d8291aeff502abf7302" => :el_capitan
    sha256 "e0c0efa03e01d59dec2832d9e88c833860263125d251e1006cede5fdd9a8ffed" => :yosemite
  end

  option "with-mysql", "Compile with MySQL persistent queue enabled"
  option "with-postgresql", "Compile with Postgresql persistent queue enabled"

  # https://bugs.launchpad.net/gearmand/+bug/1318151 - Still ongoing as of 1.1.14
  # https://bugs.launchpad.net/gearmand/+bug/1236815 - Still ongoing as of 1.1.14
  # https://github.com/Homebrew/homebrew/issues/33246 - Still ongoing as of 1.1.14
  patch :DATA

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libpqxx" if build.with? "postgresql"
  depends_on :mysql => :optional
  depends_on :postgresql => :optional
  depends_on "hiredis" => :optional
  depends_on "libmemcached" => :optional
  depends_on "openssl" => :optional
  depends_on "wolfssl" => :optional
  depends_on "tokyo-cabinet" => :optional

  def install
    # https://bugs.launchpad.net/gearmand/+bug/1368926
    Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
      next unless /std::unique_ptr/ =~ File.read(test_file)
      inreplace test_file, "std::unique_ptr", "std::auto_ptr"
    end

    args = [
      "--prefix=#{prefix}",
      "--localstatedir=#{var}",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--disable-libdrizzle",
      "--with-boost=#{Formula["boost"].opt_prefix}",
      "--with-sqlite3",
    ]

    if build.with? "cyassl"
      args << "--enable-ssl" << "--enable-cyassl"
    elsif build.with? "openssl"
      args << "--enable-ssl" << "--with-openssl=#{Formula["openssl"].opt_prefix}" << "--disable-cyassl"
    else
      args << "--disable-ssl" << "--disable-cyassl"
    end

    if build.with? "postgresql"
      args << "--enable-libpq" << "--with-postgresql=#{Formula["postgresql"].opt_bin}/pg_config"
    else
      args << "--disable-libpq" << "--without-postgresql"
    end

    if build.with? "libmemcached"
      args << "--enable-libmemcached" << "--with-memcached=#{Formula["memcached"].opt_bin}/memcached"
    else
      args << "--disable-libmemcached" << "--without-memcached"
    end

    args << "--disable-libtokyocabinet" if build.without? "tokyo-cabinet"

    args << (build.with?("mysql") ? "--with-mysql=#{Formula["mysql"].opt_bin}/mysql_config" : "--without-mysql")
    args << (build.with?("hiredis") ? "--enable-hiredis" : "--disable-hiredis")

    ENV.append_to_cflags "-DHAVE_HTONLL"

    (var/"log").mkpath
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "gearmand -d"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/gearmand</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match /gearman\s*Error in usage/, shell_output("#{bin}/gearman --version 2>&1", 1)
  end
end

__END__
diff --git a/libgearman-1.0/gearman.h b/libgearman-1.0/gearman.h
index 7f6d5e7..8f7a8f0 100644
--- a/libgearman-1.0/gearman.h
+++ b/libgearman-1.0/gearman.h
@@ -50,7 +50,11 @@
 #endif
 
 #ifdef __cplusplus
+#ifdef _LIBCPP_VERSION
 #  include <cinttypes>
+#else
+#  include <tr1/cinttypes>
+#endif
 #  include <cstddef>
 #  include <cstdlib>
 #  include <ctime>

diff --git a/libgearman/byteorder.cc b/libgearman/byteorder.cc
index 674fed9..96f0650 100644
--- a/libgearman/byteorder.cc
+++ b/libgearman/byteorder.cc
@@ -65,6 +65,8 @@ static inline uint64_t swap64(uint64_t in)
 }
 #endif
 
+#ifndef HAVE_HTONLL
+
 uint64_t ntohll(uint64_t value)
 {
   return swap64(value);
@@ -74,3 +76,5 @@ uint64_t htonll(uint64_t value)
 {
   return swap64(value);
 }
+
+#endif
\ No newline at end of file
diff --git a/libgearman/client.cc b/libgearman/client.cc
index 3db2348..4363b36 100644
--- a/libgearman/client.cc
+++ b/libgearman/client.cc
@@ -599,7 +599,7 @@ gearman_return_t gearman_client_add_server(gearman_client_st *client_shell,
   {
     Client* client= client_shell->impl();
 
-    if (gearman_connection_create(client->universal, host, port) == false)
+    if (gearman_connection_create(client->universal, host, port) == NULL)
     {
       assert(client->error_code() != GEARMAN_SUCCESS);
       return client->error_code();
@@ -614,7 +614,7 @@ gearman_return_t gearman_client_add_server(gearman_client_st *client_shell,
 
 gearman_return_t Client::add_server(const char *host, const char* service_)
 {
-  if (gearman_connection_create(universal, host, service_) == false)
+  if (gearman_connection_create(universal, host, service_) == NULL)
   {
     assert(error_code() != GEARMAN_SUCCESS);
     return error_code();
@@ -946,7 +946,7 @@ gearman_return_t gearman_client_job_status(gearman_client_st *client_shell,
       *denominator= do_task->impl()->denominator;
     }
 
-    if (is_known == false and is_running == false)
+    if (! is_known and ! is_running)
     {
       if (do_task->impl()->options.is_running) 
       {
