class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.3.1.tar.bz2"
  sha256 "d5146c04098ee94b9377ee491ebb3fd5eb061d7b24262f4a8e1a89f2ed3fc245"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "42b5af5d9882ad21a4b0105fc30f4d263695aaecb4f155bfab56ca87c4fef176" => :big_sur
    sha256 "a2157c837b834c7d428066e64d375636917066ea37c48935afec632c2fe539d9" => :catalina
    sha256 "3221d27d70b3d023b0bf7ab053f269e3ae0ae31f3b7697e7a495687dba252ec9" => :mojave
    sha256 "26266299abce6649649c05949369f11139b418bc0bbca23ffb65fa1dbf1640db" => :high_sierra
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "sqlite"

  uses_from_macos "curl"

  # fix for compatibility issue with boost 1.73
  # port of PR https://github.com/PowerDNS/pdns/pull/9070
  patch :DATA

  def install
    # Fix "configure: error: cannot find boost/program_options.hpp"
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options manual: "pdns_server start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/pdns_server</string>
        </array>
        <key>EnvironmentVariables</key>
        <key>KeepAlive</key>
        <true/>
        <key>SHAuthorizationRight</key>
        <string>system.preferences</string>
      </dict>
      </plist>
    EOS
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end

__END__
diff --git a/pdns/ixfrdist-web.cc b/pdns/ixfrdist-web.cc
index 485e720..58e4720 100644
--- a/pdns/ixfrdist-web.cc
+++ b/pdns/ixfrdist-web.cc
@@ -32,7 +32,7 @@ IXFRDistWebServer::IXFRDistWebServer(const ComboAddress &listenAddress, const Ne
 {
   d_ws->setACL(acl);
   d_ws->setLogLevel(loglevel);
-  d_ws->registerWebHandler("/metrics", boost::bind(&IXFRDistWebServer::getMetrics, this, _1, _2));
+  d_ws->registerWebHandler("/metrics", std::bind(&IXFRDistWebServer::getMetrics, this, std::placeholders::_1, std::placeholders::_2));
   d_ws->bind();
 }

diff --git a/pdns/webserver.cc b/pdns/webserver.cc
index eafd305..8b19b76 100644
--- a/pdns/webserver.cc
+++ b/pdns/webserver.cc
@@ -107,7 +107,7 @@ static void bareHandlerWrapper(WebServer::HandlerFunction handler, YaHTTP::Reque

 void WebServer::registerBareHandler(const string& url, HandlerFunction handler)
 {
-  YaHTTP::THandlerFunction f = boost::bind(&bareHandlerWrapper, handler, _1, _2);
+  YaHTTP::THandlerFunction f = std::bind(&bareHandlerWrapper, handler, std::placeholders::_1, std::placeholders::_2);
   YaHTTP::Router::Any(url, f);
 }

@@ -179,7 +179,7 @@ void WebServer::apiWrapper(WebServer::HandlerFunction handler, HttpRequest* req,
 }

 void WebServer::registerApiHandler(const string& url, HandlerFunction handler, bool allowPassword) {
-  HandlerFunction f = boost::bind(&WebServer::apiWrapper, this, handler, _1, _2, allowPassword);
+  HandlerFunction f = std::bind(&WebServer::apiWrapper, this, handler, std::placeholders::_1, std::placeholders::_2, allowPassword);
   registerBareHandler(url, f);
 }

@@ -196,7 +196,7 @@ void WebServer::webWrapper(WebServer::HandlerFunction handler, HttpRequest* req,
 }

 void WebServer::registerWebHandler(const string& url, HandlerFunction handler) {
-  HandlerFunction f = boost::bind(&WebServer::webWrapper, this, handler, _1, _2);
+  HandlerFunction f = std::bind(&WebServer::webWrapper, this, handler, std::placeholders::_1, std::placeholders::_2);
   registerBareHandler(url, f);
 }

diff --git a/pdns/ws-auth.cc b/pdns/ws-auth.cc
index 8a8c433..df0e633 100644
--- a/pdns/ws-auth.cc
+++ b/pdns/ws-auth.cc
@@ -2328,8 +2328,8 @@ void AuthWebServer::webThread()
       d_ws->registerApiHandler("/api", &apiDiscovery);
     }
     if (::arg().mustDo("webserver")) {
-      d_ws->registerWebHandler("/style.css", boost::bind(&AuthWebServer::cssfunction, this, _1, _2));
-      d_ws->registerWebHandler("/", boost::bind(&AuthWebServer::indexfunction, this, _1, _2));
+      d_ws->registerWebHandler("/style.css", std::bind(&AuthWebServer::cssfunction, this, std::placeholders::_1, std::placeholders::_2));
+      d_ws->registerWebHandler("/", std::bind(&AuthWebServer::indexfunction, this, std::placeholders::_1, std::placeholders::_2));
     }
     d_ws->go();
   }
