class Jlog < Formula
  desc "Pure C message queue with subscribers and publishers for logs"
  homepage "https://labs.omniti.com/labs/jlog"
  url "https://github.com/omniti-labs/jlog/archive/2.2.1.2.tar.gz"
  sha256 "14a5cf3306390f7f47a1ad88a0fd286415a5c14fa3cab7b6d5e928f3f1ff79bc"
  head "https://github.com/omniti-labs/jlog.git"

  bottle do
    cellar :any
    sha256 "2b7a0ccbe25602cd4ec2c6d440dbf60445073ef84d0056f9a677ef21aa6e50e9" => :el_capitan
    sha256 "3786dbbb412a0236208a87981cad1d78e5b5baad43571b8c41f3daf2d31d6157" => :yosemite
    sha256 "7260e90e8cf8255c2ec82ae04e7eeee5a69046222c58172229275f2ea9dee432" => :mavericks
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
