class Jlog < Formula
  desc "Pure C message queue with subscribers and publishers for logs"
  homepage "https://labs.omniti.com/labs/jlog"
  url "https://github.com/omniti-labs/jlog/archive/refs/tags/2.6.0.tar.gz"
  sha256 "c3c6e745557f789c2cef3e3760e3c68ee585727a0d55c14ad9cb3e8232f4e46b"
  license "BSD-3-Clause"
  head "https://github.com/omniti-labs/jlog.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f724763ab3cb0f20315a2e5b3248cb93a5f3ae752233eb22604ab31df032c6b0"
    sha256 cellar: :any,                 arm64_sequoia:  "2a78a80b0f6624a86af2e2f4ac2ddff08d2182d801d88213c14a816225b66e45"
    sha256 cellar: :any,                 arm64_sonoma:   "29000316d005c75482135908e0b6f8ba9ed9bc5046b449133725237ad981b3ca"
    sha256 cellar: :any,                 arm64_ventura:  "1ea5287e2fb6f3cfe8fc0c2b91f4012ac92756408132d0543fe9fb5db2726d4c"
    sha256 cellar: :any,                 arm64_monterey: "500e84aeed8bcdd929bef2023db9b040d0e1ba5043362f91dfdc5238a1d258d8"
    sha256 cellar: :any,                 sonoma:         "61f8f9bd4bc83160c4680f9df02462d64c06a2125488b3f421e80753218bc786"
    sha256 cellar: :any,                 ventura:        "ed19d61911e281161bfd89926aa405a3b50b0519c5d0c9b9016685c862cc3255"
    sha256 cellar: :any,                 monterey:       "c856df10689f774ee8a7ee58c80edf754573b509c8769e477bbfc05735332def"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3bad683d45631a54ba97c2191786efcd88bb8e7ad1bbf0e8e97b417607f5c61c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b59c62ae218826677a96203de736d341929e2f7490957eeb125d9b720e698ec"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"jlogtest.c").write <<~C
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
    C
    system ENV.cc, "jlogtest.c", "-I#{include}", "-L#{lib}", "-ljlog", "-o", "jlogtest"
    system testpath/"jlogtest"
  end
end
