class Jlog < Formula
  desc "Pure C message queue with subscribers and publishers for logs"
  homepage "https://labs.omniti.com/labs/jlog"
  url "https://github.com/omniti-labs/jlog/archive/2.5.3.tar.gz"
  sha256 "66730afc62aa9c9f93ef686998a5396f8721edca3750097d4a2848a688d55bf9"
  license "BSD-3-Clause"
  head "https://github.com/omniti-labs/jlog.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a47745b2bd24e09f7be0a6e55171d9e989c03914747e732153358ab76176fae6"
    sha256 cellar: :any,                 arm64_big_sur:  "aae9bc7604223b7535c8787af8737c7fb8e8e357a4106aafffcdc6ebf2d5e228"
    sha256 cellar: :any,                 monterey:       "bdb8f7eaef8cd4387ae246fb64d92999985c91dd9057eb08d18df4e3ccb74a04"
    sha256 cellar: :any,                 big_sur:        "bf009b8acfcfe3b702b017ef8e5c232fc791722fe505b71a0c3fabdeebd13443"
    sha256 cellar: :any,                 catalina:       "28a606466256bf030942104c0e7b5618b442ecee7bcd7498cfac9f2cbb098ebc"
    sha256 cellar: :any,                 mojave:         "e45a56ff580b67b3a17407996d72768b57f06b6f7878ca8320dc8befe8f2793f"
    sha256 cellar: :any,                 high_sierra:    "583bdc22413565285d5f3551be33c17d12e18a25b665e57076332147cfb283d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba179ee6b8b414864eea944003ac434c532e53f731e2593ac6e9978568a5b7fa"
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
