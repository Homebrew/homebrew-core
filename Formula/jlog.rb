class Jlog < Formula
  desc "Pure C message queue with subscribers and publishers for logs"
  homepage "https://labs.omniti.com/labs/jlog"
  url "https://github.com/omniti-labs/jlog/archive/2.5.4.tar.gz"
  sha256 "a6f00f9f41d3664a2f66f6c6aee0d33d6f295354f13a5f7f4033ca7ed20685cd"
  license "BSD-3-Clause"
  head "https://github.com/omniti-labs/jlog.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34c8486ef107bd15562d5b15b20a1892d4c859a3407c39c90b45b9f6497764f4"
    sha256 cellar: :any,                 arm64_monterey: "ca940d44eec020e82f8416245f4634d543ff471150e4579817344d944c445085"
    sha256 cellar: :any,                 arm64_big_sur:  "32b7e00c10405ce4aa979adfef936eb67e59abc62f016df1a3b82e4e98c2393d"
    sha256 cellar: :any,                 ventura:        "d6964c475f6e70d7025dc37da7c67dac1c3bdcd7efba3dd3a9c927dd1860477c"
    sha256 cellar: :any,                 monterey:       "f65c6a850701989de8355e2db39e479103090b2b22c073c0f461d4c3e74818c2"
    sha256 cellar: :any,                 big_sur:        "3968856ea5fbca1aa88feae8c9978d08bf35b380dcf486841c3e71a3937e794e"
    sha256 cellar: :any,                 catalina:       "ef9a6e2a85b5bdb48b50a6e8f86e53288c1e82ed7d1a1b404335b8e3c3db84fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6349b0d48318cc98416da8a2481b4524a3b03b8b510cf1a2b043d78b3b142459"
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
