class Jlog < Formula
  desc "Pure C message queue with subscribers and publishers for logs"
  homepage "https://labs.omniti.com/labs/jlog"
  url "https://github.com/omniti-labs/jlog/archive/2.4.0.tar.gz"
  sha256 "3843c48ca5c0debe22ea2d2f7de5c1a17a046699e628fd0a0a41ada14b0fece7"
  head "https://github.com/omniti-labs/jlog.git"

  bottle do
    cellar :any
    sha256 "80dc6e45c65a7996c623393b47b21c453de726ef69a319ef817d31e1e727e3c0" => :mojave
    sha256 "7459242c359ce4afe0b57ed447723f35c496ba6d633eb26fe59f86aca126c113" => :high_sierra
    sha256 "f8578c0d25a1c317d1b534231b0a6c50038288105ee7dfd07efa8e31183874bb" => :sierra
    sha256 "a3432d256f8fd10b9dafd442167a076311c8b19640326c9a5218b4ca231c3347" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"jlogtest.c").write <<~EOS
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
    EOS
    system ENV.cc, "jlogtest.c", "-I#{include}", "-L#{lib}", "-ljlog", "-o", "jlogtest"
    system testpath/"jlogtest"
  end
end
