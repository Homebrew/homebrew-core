class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"
  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.
  license "MPL-2.0"
  revision 1
  version_scheme 1

  stable do
    url "https://downloads.isc.org/isc/bind9/9.20.22/bind-9.20.22.tar.xz"
    sha256 "cba92ff631b949655f475fe4b54290f6860fd0070d399f2279f6437c0d383ec6"

    depends_on "readline" # TODO: Remove in 9.22
  end

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d9ed734e5ea2b4d7ab80348117140b155a18eda8a6e40c479e6742041580e890"
    sha256 arm64_sequoia: "635561c6d2536d7f9d1f09e81377d944e926f5b8afe49b8b64e55a02b465d22a"
    sha256 arm64_sonoma:  "d6259270ba06a432733b383e8281a45c90f88facc54806e667201481629cb5ab"
    sha256 sonoma:        "a18be96084b8116749fdb7c89cfc4b4c40b9051b9c4f8f61709c2f8faa45f732"
    sha256 arm64_linux:   "b8034ecff3194e43c817e717a64a77890804d584d36af4a8858ac1df942c0159"
    sha256 x86_64_linux:  "ae73c86b5cce1c22282a9175f2ad234136633a3ea8d627f52884367767d33b63"
  end

  head do
    url "https://gitlab.isc.org/isc-projects/bind9.git", branch: "main"

    depends_on "meson" => :build
    depends_on "ninja" => :build
    depends_on "lmdb"

    uses_from_macos "libedit"
  end

  depends_on "pkgconf" => :build

  depends_on "jemalloc"
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@4"
  depends_on "userspace-rcu"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "libcap"
    depends_on "zlib-ng-compat"
  end

  # OpenSSL 4 cleanup can allocate after BIND's OpenSSL memory context is unsafe.
  patch :DATA

  def install
    # Apply macOS 15+ libxml2 deprecation to all macOS versions.
    # This allows our macOS 14-built Intel bottle to work on macOS 15+
    # and also cover the case where a user on macOS 14- updates to macOS 15+.
    ENV.append_to_cflags "-DLIBXML_HAS_DEPRECATED_MEMORY_ALLOCATION_FUNCTIONS" if OS.mac?

    if build.head?
      args = %W[
        -Dlocalstatedir=#{var}
        -Dsysconfdir=#{pkgetc}
      ]

      system "meson", "setup", "build", *args, *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    else
      args = [
        "--sysconfdir=#{pkgetc}",
        "--localstatedir=#{var}",
        "--with-json-c",
        "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
        "--with-openssl=#{Formula["openssl@4"].opt_prefix}",
        "--without-lmdb",
      ]

      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end

    (buildpath/"named.conf").write named_conf
    system sbin/"rndc-confgen", "-a", "-c", "#{buildpath}/rndc.key"
    pkgetc.install "named.conf", "rndc.key"

    (var/"log/named").mkpath
    (var/"named").mkpath
  end

  def named_conf
    <<~EOS
      logging {
          category default {
              _default_log;
          };
          channel _default_log {
              file "#{var}/log/named/named.log" versions 10 size 1m;
              severity info;
              print-time yes;
          };
      };

      options {
          directory "#{var}/named";
      };
    EOS
  end

  service do
    run [opt_sbin/"named", "-f", "-L", var/"log/named/named.log"]
    require_root true
  end

  test do
    system bin/"dig", "-v"
    system bin/"dig", "brew.sh"
    system bin/"dig", "ü.cl"
  end
end

__END__
diff --git a/lib/isc/tls.c b/lib/isc/tls.c
--- a/lib/isc/tls.c
+++ b/lib/isc/tls.c
@@ -80,7 +80,8 @@ static atomic_bool handle_fatal = true;
 static atomic_bool handle_fatal = false;
 #endif
 
-#if !defined(LIBRESSL_VERSION_NUMBER) && OPENSSL_VERSION_NUMBER >= 0x30000000L
+#if !defined(LIBRESSL_VERSION_NUMBER) && OPENSSL_VERSION_NUMBER >= 0x30000000L && \
+	OPENSSL_VERSION_NUMBER < 0x40000000L
 /*
  * This was crippled with LibreSSL, so just skip it:
  * https://cvsweb.openbsd.org/src/lib/libcrypto/Attic/mem.c
@@ -154,7 +155,8 @@ isc__tls_initialize(void) {
 	isc_mem_setname(isc__tls_mctx, "OpenSSL");
 	isc_mem_setdestroycheck(isc__tls_mctx, false);
 
-#if !defined(LIBRESSL_VERSION_NUMBER) && OPENSSL_VERSION_NUMBER >= 0x30000000L
+#if !defined(LIBRESSL_VERSION_NUMBER) && OPENSSL_VERSION_NUMBER >= 0x30000000L && \
+	OPENSSL_VERSION_NUMBER < 0x40000000L
 	/*
 	 * CRYPTO_set_mem_(_ex)_functions() returns 1 on success or 0 on
 	 * failure, which means OpenSSL already allocated some memory.  There's
