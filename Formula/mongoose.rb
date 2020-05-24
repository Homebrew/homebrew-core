class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.18.tar.gz"
  sha256 "f5c10346abc9c72f7cac7885d853ca064fb09aad57580433941a8fd7a3543769"

  bottle do
    cellar :any
    sha256 "3eb55e73c26957e647dcc4f978fa7d4d5ae2b223fa631d208f07b341d26ac0d5" => :catalina
    sha256 "cb43e1b9e539db8348d6038fbe56ca787b02428f3c585cd0528c3c4521a26222" => :mojave
    sha256 "a65aaee3abb441a26728b8f08c5fa81845f5636d676fadaba5881da4da04ee71" => :high_sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "suite-sparse", :because => "suite-sparse vendors libmongoose.dylib"

  patch :DATA

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/simplest_web_server" do
      system "make"
      bin.install "simplest_web_server" => "mongoose"
    end

    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
    include.install "mongoose.h"
    lib.install "libmongoose.dylib"
    pkgshare.install "examples", "jni"
    doc.install Dir["docs/*"]
  end

  test do
    port = free_port.to_s
    ENV["HTTP_PORT"] = port

    (testpath/"hello.html").write <<~EOS
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hi!</p>
        </body>
      </html>
    EOS

    begin
      pid = fork { exec "#{bin}/mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl -s http://localhost:#{port}/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

__END__
diff --git a/examples/simplest_web_server/simplest_web_server.c b/examples/simplest_web_server/simplest_web_server.c
index 94d5933..407d7ed 100644
--- a/examples/simplest_web_server/simplest_web_server.c
+++ b/examples/simplest_web_server/simplest_web_server.c
@@ -3,7 +3,7 @@

 #include "mongoose.h"

-static const char *s_http_port = "8000";
+static const char *default_http_port = "8000";
 static struct mg_serve_http_opts s_http_server_opts;

 static void ev_handler(struct mg_connection *nc, int ev, void *p) {
@@ -17,6 +17,10 @@ int main(void) {
   struct mg_connection *nc;

   mg_mgr_init(&mgr, NULL);
+
+  const char *http_port = getenv("HTTP_PORT");
+  const char *s_http_port = (http_port != NULL)? http_port: default_http_port;
+
   printf("Starting web server on port %s\n", s_http_port);
   nc = mg_bind(&mgr, s_http_port, ev_handler);
   if (nc == NULL) {
