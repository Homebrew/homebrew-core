class Jlog < Formula
  desc "Pure C message queue with subscribers and publishers for logs"
  homepage "https://labs.omniti.com/labs/jlog"
  head "https://github.com/omniti-labs/jlog.git"

  stable do
    url "https://github.com/omniti-labs/jlog/archive/2.2.0.tar.gz"
    sha256 "81b7a9d86a4ee8dbc3cc08a7032ee0ecd31b531573525474be298bd4f1404e53"

    # Fixes `make install` to depend on `make all`
    patch do
      url "https://github.com/omniti-labs/jlog/commit/38955d8ca07e9c2433231a89c9702a72bc3707f2.diff"
      sha256 "f8630d425227533d1641efbb7a3c489e859b5190c9a82a5f8fb4b81e1e8cd946"
    end
  end

  bottle do
    cellar :any
    sha256 "69c2aa1f1d241eeb2cfb4662367649467627263bb7f4ab03352fe15dff599314" => :el_capitan
    sha256 "8430563a9007fbfe9381ee2e551341fd24bd196c41ce337737ab18756f8ee2e9" => :yosemite
    sha256 "cd53653f705bcdef61426a1a35938b8a836a91846b8b5680010d7ce7987dad8f" => :mavericks
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
