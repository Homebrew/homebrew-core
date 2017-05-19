class Jlog < Formula
  desc "Pure C message queue with subscribers and publishers for logs"
  homepage "https://labs.omniti.com/labs/jlog"
  url "https://github.com/omniti-labs/jlog/archive/2.3.0.tar.gz"
  sha256 "b8912e8de791701d664965c30357c4bbc68df3206b22f7ea0029e7179b02079a"
  head "https://github.com/omniti-labs/jlog.git"

  bottle do
    cellar :any
    sha256 "37fbd09023ab291b9480006004a7634dfb266aa74ff7d55b3c8c3567c9bc973f" => :sierra
    sha256 "959e0c08b5adb6b1ff7e8dc660366f56d7e24629e3aef8c7623f68723cc62f1f" => :el_capitan
    sha256 "dc25575310094b2dd1de67014ec968c45506723bc59d0ca7aa6491d0c0f8b2b7" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"jlogtest.c").write <<-EOF.undent
      #include <stdio.h>
      #include <jlog.h>
      int main() {
        jlog_ctx *ctx;
        const char *path = "#{testpath}/jlogexample";
        int rv;

        // First, ensure that the jlog is created
        ctx = jlog_new(path);
        if (jlog_ctx_init(ctx) != 0) {
          if(jlog_ctx_err(ctx) != JLOG_ERR_CREATE_EXISTS) {
            fprintf(stderr, "jlog_ctx_init failed: %d %s\\n", jlog_ctx_err(ctx), jlog_ctx_err_string(ctx));
            exit(1);
          }
          // Make sure it knows about our subscriber(s)
          jlog_ctx_add_subscriber(ctx, "one", JLOG_BEGIN);
          jlog_ctx_add_subscriber(ctx, "two", JLOG_BEGIN);
        }

        // Now re-open for writing
        jlog_ctx_close(ctx);
        ctx = jlog_new(path);
        if (jlog_ctx_open_writer(ctx) != 0) {
           fprintf(stderr, "jlog_ctx_open_writer failed: %d %s\\n", jlog_ctx_err(ctx), jlog_ctx_err_string(ctx));
           exit(0);
        }

        // Send in some data
        rv = jlog_ctx_write(ctx, "hello\\n", strlen("hello\\n"));
        if (rv != 0) {
          fprintf(stderr, "jlog_ctx_write_message failed: %d %s\\n", jlog_ctx_err(ctx), jlog_ctx_err_string(ctx));
        }
        jlog_ctx_close(ctx);
      }
    EOF
    system ENV.cc, "jlogtest.c", "-I#{include}", "-ljlog", "-o", "jlogtest"
    system testpath/"jlogtest"
  end
end
