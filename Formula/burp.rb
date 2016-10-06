class Burp < Formula
  desc "Network backup and restore"
  homepage "http://burp.grke.org/"
  revision 1

  stable do
    url "https://github.com/grke/burp/archive/1.4.40.tar.gz"
    sha256 "2e6a9a28453a11f3e36d0beefa185e72e7781a8718b55d3101144c9900752d6f"

    patch :DATA
  end

  bottle do
    cellar :any
    sha256 "f069164dc6c908f87c975526fd7821b4b9be2514a3b8c5884b844a400556c615" => :sierra
    sha256 "2342aea1a1ac623c8154c1d64a7b583eae62a6177136173d73adada6fd58380e" => :el_capitan
    sha256 "a892287dbaf7a4d5557a471b16d6ce09a5dc0faab004635bc0c90b79d07e92b3" => :yosemite
    sha256 "d3b8cc95839835dd9ba9574444d5cf7394d398376fe2a06fcd3ba9a00b395476" => :mavericks
  end

  devel do
    url "https://github.com/grke/burp/archive/2.0.48.tar.gz"
    sha256 "62c8304afc30f764eb16c6f0794e593d3ad24850261d1a3b705156bded16116a"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git",
          :tag => "v2.0.1",
          :revision => "539b4504b052cfca54ed66b82ca99e3aed403d46"
    end
  end

  head do
    url "https://github.com/grke/burp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git"
    end
  end

  depends_on "librsync"
  depends_on "openssl"

  def install
    unless build.stable?
      resource("uthash").stage do
        system "make", "-C", "libut"
        (buildpath/"uthash/lib").install "libut/libut.a"
        (buildpath/"uthash/include").install Dir["src/*"]
      end

      ENV.prepend "CPPFLAGS", "-I#{buildpath}/uthash/include"
      ENV.prepend "LDFLAGS", "-L#{buildpath}/uthash/lib"

      system "autoreconf", "-fiv"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/burp",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}"
    if build.stable?
      system "make", "install"
    else
      system "make", "install-all"
    end
  end

  def post_install
    (var/"run").mkpath
    (var/"spool/burp").mkpath
  end

  def caveats; <<-EOS.undent
    Before installing the launchd entry you should configure your burp client in
      #{etc}/burp/burp.conf
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>UserName</key>
      <string>root</string>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/burp</string>
        <string>-a</string>
        <string>t</string>
      </array>
      <key>StartInterval</key>
      <integer>1200</integer>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"burp", "-v"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index ac22a24..0cf112b 100755
--- a/Makefile.in
+++ b/Makefile.in
@@ -90,8 +90,8 @@ installdirs:
 	$(MKDIR) $(DESTDIR)$(sbindir)
 	$(MKDIR) $(DESTDIR)$(sysconfdir)
 	$(MKDIR) $(DESTDIR)$(sysconfdir)/CA-client
-	$(MKDIR) $(DESTDIR)/var/run
-	$(MKDIR) $(DESTDIR)/var/spool/burp
+	$(MKDIR) HOMEBREW_PREFIX/var/run
+	$(MKDIR) HOMEBREW_PREFIX/var/spool/burp
 	@if [ ! -d $(DESTDIR)$(sysconfdir)/clientconfdir ] ; then $(MKDIR) $(DESTDIR)$(sysconfdir)/clientconfdir ; cp configs/server/clientconfdir/testclient $(DESTDIR)$(sysconfdir)/clientconfdir/testclient ; fi
 	@if [ ! -d $(DESTDIR)$(sysconfdir)/clientconfdir/incexc ] ; then $(MKDIR) $(DESTDIR)$(sysconfdir)/clientconfdir/incexc ; cp configs/server/clientconfdir/incexc $(DESTDIR)$(sysconfdir)/clientconfdir/incexc/example ; fi
 	@if [ ! -d $(DESTDIR)$(sysconfdir)/autoupgrade/client ] ; then $(MKDIR) $(DESTDIR)$(sysconfdir)/autoupgrade/client ; fi
diff --git a/configs/client/burp.conf b/configs/client/burp.conf
index 1b47476..76fcd8d 100644
--- a/configs/client/burp.conf
+++ b/configs/client/burp.conf
@@ -5,7 +5,7 @@ port = 4971
 server = 127.0.0.1
 password = abcdefgh
 cname = testclient
-pidfile = /var/run/burp.client.pid
+pidfile = HOMEBREW_PREFIX/var/run/burp.client.pid
 syslog = 0
 stdout = 1
 progress_counter = 1
diff --git a/configs/server/burp.conf b/configs/server/burp.conf
index 45a4b70..c9081d0 100644
--- a/configs/server/burp.conf
+++ b/configs/server/burp.conf
@@ -3,9 +3,9 @@
 mode = server
 port = 4971
 status_port = 4972
-directory = /var/spool/burp
-clientconfdir = /etc/burp/clientconfdir
-pidfile = /var/run/burp.server.pid
+directory = HOMEBREW_PREFIX/var/spool/burp
+clientconfdir = HOMEBREW_PREFIX/etc/burp/clientconfdir
+pidfile = HOMEBREW_PREFIX/var/run/burp.server.pid
 hardlinked_archive = 0
 working_dir_recovery_method = delete
 max_children = 5
diff --git a/configs/client/burp.conf b/configs/client/burp.conf
index 76fcd8d..9cd7edb 100644
--- a/configs/client/burp.conf
+++ b/configs/client/burp.conf
@@ -41,17 +41,17 @@ cross_all_filesystems=0
 
 # Uncomment the following lines to automatically generate a certificate signing
 # request and send it to the server.
-ca_burp_ca = /usr/sbin/burp_ca
-ca_csr_dir = /etc/burp/CA-client
+ca_burp_ca = HOMEBREW_PREFIX/bin/burp_ca
+ca_csr_dir = HOMEBREW_PREFIX/etc/burp/CA-client
 
 # SSL certificate authority - same file on both server and client
-ssl_cert_ca = /etc/burp/ssl_cert_ca.pem
+ssl_cert_ca = HOMEBREW_PREFIX/etc/burp/ssl_cert_ca.pem
 
 # Client SSL certificate
-ssl_cert = /etc/burp/ssl_cert-client.pem
+ssl_cert = HOMEBREW_PREFIX/etc/burp/ssl_cert-client.pem
 
 # Client SSL key
-ssl_key = /etc/burp/ssl_cert-client.key
+ssl_key = HOMEBREW_PREFIX/etc/burp/ssl_cert-client.key
 
 # Client SSL ciphers
 #ssl_ciphers = 
