class Couchdb < Formula
  desc "Apache CouchDB database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=couchdb/source/3.1.1/apache-couchdb-3.1.1.tar.gz"
  mirror "https://archive.apache.org/dist/couchdb/source/3.1.1/apache-couchdb-3.1.1.tar.gz"
  sha256 "8ffe766bba2ba39a7b49689a0732afacf69caffdf8e2d95447e82fb173c78ca3"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any, big_sur:  "a5f39bc7837033ef94ce64bd004ab640d0dbcc36723048a5eecbf0fe7f79b83e"
    sha256 cellar: :any, catalina: "5736d9943ec1ac5935f72eb6fb102a34b9533a796e7701baf4b7e000360b46c6"
    sha256 cellar: :any, mojave:   "d285b3dccb394ae6e73f6686acb541505f5c3fe31c42fb1d4b9adfcfef6053c3"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "erlang@22" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "icu4c"
  depends_on "openssl@1.1"
  depends_on "spidermonkey@78"

  conflicts_with "ejabberd", because: "both install `jiffy` lib"

  fails_with :clang # c++20 support

  # resolve rejections of patches below
  patch :DATA

  # feat(couchjs): add support for SpiderMonkey 86
  patch do
    url "https://github.com/apache/couchdb/commit/a411fe220f94be73b9364fc0e923b8401d4e73ff.patch?full_index=1"
    sha256 "1bc52ae8f602701a27262a4174006306fa1d357d41944d82b3061bf7b541639b"
  end

  # Add support for Spidermonkey 78
  patch do
    url "https://github.com/apache/couchdb/commit/37b5eed5024b9a57a134260794ea80032a1149f8.patch?full_index=1"
    sha256 "caf4a73d6e0c7edbe508be94d9ca47da3cc65bf3900cb22151c2094bba7ba9cb"
  end

  def install
    spidermonkey = Formula["spidermonkey@78"]
    inreplace "src/couch/rebar.config.script",
              "/usr/local/include/mozjs-#{spidermonkey.version.major}",
              "#{spidermonkey.opt_include}/mozjs-#{spidermonkey.version.major}"
    inreplace "src/couch/rebar.config.script",
              "-L/usr/local/lib -std=c++20 -lmozjs-78 -lm",
              "-L#{spidermonkey.opt_lib} -std=c++20 -lmozjs-78 -lm"
    system "./configure", "--spidermonkey-version", spidermonkey.version.major
    system "make", "release"
    # setting new database dir
    inreplace "rel/couchdb/etc/default.ini", "./data", "#{var}/couchdb/data"
    # remove windows startup script
    File.delete("rel/couchdb/bin/couchdb.cmd") if File.exist?("rel/couchdb/bin/couchdb.cmd")
    # install files
    prefix.install Dir["rel/couchdb/*"]
    if File.exist?(prefix/"Library/LaunchDaemons/org.apache.couchdb.plist")
      (prefix/"Library/LaunchDaemons/org.apache.couchdb.plist").delete
    end
  end

  def post_install
    # creating database directory
    (var/"couchdb/data").mkpath
  end

  def caveats
    <<~EOS
      CouchDB 3.x requires a set admin password set before startup.
      Add one to your #{etc}/local.ini before starting CouchDB e.g.:
        [admins]
        admin = youradminpassword
    EOS
  end

  plist_options manual: "couchdb"

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
          <string>#{bin}/couchdb</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    cp_r prefix/"etc", testpath
    port = free_port
    inreplace "#{testpath}/etc/default.ini", "port = 5984", "port = #{port}"
    inreplace "#{testpath}/etc/default.ini", "#{var}/couchdb/data", "#{testpath}/data"
    inreplace "#{testpath}/etc/local.ini", ";admin = mysecretpassword", "admin = mysecretpassword"

    fork do
      exec "#{bin}/couchdb -couch_ini #{testpath}/etc/default.ini #{testpath}/etc/local.ini"
    end
    sleep 30

    output = JSON.parse shell_output("curl --silent localhost:#{port}")
    assert_equal "Welcome", output["couchdb"]
  end
end

__END__
--- a/src/couch/rebar.config.script
+++ b/src/couch/rebar.config.script
@@ -76,7 +76,7 @@ ConfigH = [
     {"JSSCRIPT_TYPE", "JSObject*"},
     {"COUCHJS_NAME", "\"" ++ CouchJSName++ "\""},
     {"PACKAGE", "\"apache-couchdb\""},
-    {"PACKAGE_BUGREPORT", "\"https://issues.apache.org/jira/browse/COUCHDB\""},
+    {"PACKAGE_BUGREPORT", "\"https://github.com/apache/couchdb/issues\""},
     {"PACKAGE_NAME", "\"Apache CouchDB\""},
     {"PACKAGE_STRING", "\"Apache CouchDB " ++ Version ++ "\""},
     {"PACKAGE_VERSION", "\"" ++ Version ++ "\""}
@@ -123,38 +123,15 @@ end.
     {unix, _} when SMVsn == "60" ->
         {
             "-DXP_UNIX -I/usr/include/mozjs-60 -I/usr/local/include/mozjs-60 -std=c++14 -Wno-invalid-offsetof",
-            "-L/usr/local/lib -std=c++14 -lmozjs-60 -lm"
+            "-L/usr/local/lib -std=c++14 -lmozjs-60 -lm -lstdc++"
         };
     {unix, _} when SMVsn == "68" ->
         {
             "-DXP_UNIX -I/usr/include/mozjs-68 -I/usr/local/include/mozjs-68 -std=c++14 -Wno-invalid-offsetof",
-            "-L/usr/local/lib -std=c++14 -lmozjs-68 -lm"
+            "-L/usr/local/lib -std=c++14 -lmozjs-68 -lm -lstdc++"
         }
 end.
 
-{CURL_CFLAGS, CURL_LDFLAGS} = case lists:keyfind(with_curl, 1, CouchConfig) of
-    {with_curl, true} ->
-        case os:type() of
-            {win32, _} ->
-                {
-                    "/DHAVE_CURL",
-                    "/DHAVE_CURL libcurl.lib"
-                };
-            {unix, freebsd} ->
-                {
-                    "-DHAVE_CURL -I/usr/local/include",
-                    "-DHAVE_CURL -lcurl"
-                };
-            _ ->
-                {
-                    "-DHAVE_CURL",
-                    "-DHAVE_CURL -lcurl"
-                }
-        end;
-    _ ->
-        {"", ""}
-end.
-
 CouchJSSrc = case SMVsn of
     "1.8.5" -> ["priv/couch_js/1.8.5/*.c"];
     "60" -> ["priv/couch_js/60/*.cpp"];
@@ -164,13 +141,13 @@ end.
 CouchJSEnv = case SMVsn of
     "1.8.5" ->
         [
-            {"CFLAGS", JS_CFLAGS ++ " " ++ CURL_CFLAGS},
-            {"LDFLAGS", JS_LDFLAGS ++ " " ++ CURL_LDFLAGS}
+            {"CFLAGS", JS_CFLAGS},
+            {"LDFLAGS", JS_LDFLAGS}
         ];
     _ ->
         [
-            {"CXXFLAGS", JS_CFLAGS ++ " " ++ CURL_CFLAGS},
-            {"LDFLAGS", JS_LDFLAGS ++ " " ++ CURL_LDFLAGS}
+            {"CXXFLAGS", JS_CFLAGS},
+            {"LDFLAGS", JS_LDFLAGS}
         ]
 end.
 
@@ -237,5 +214,10 @@ AddConfig = [
 ].
 
 lists:foldl(fun({K, V}, CfgAcc) ->
-    lists:keystore(K, 1, CfgAcc, {K, V})
-end, CONFIG, AddConfig).
+    case lists:keyfind(K, 1, CfgAcc) of
+        {K, Existent} when is_list(Existent) andalso is_list(V) ->
+            lists:keystore(K, 1, CfgAcc, {K, Existent ++ V});
+        false ->
+            lists:keystore(K, 1, CfgAcc, {K, V})
+    end
+end, CONFIG, AddConfig).
\ No newline at end of file
