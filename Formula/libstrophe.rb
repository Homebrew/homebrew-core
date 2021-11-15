class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.11.0.tar.gz"
  sha256 "090185bcf5800663e18340313410e3b6e4e742e065daac9e7cfa5dbb83dab8f5"
  license any_of: ["GPL-3.0", "MIT"]
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "13e67f5e28df838ffbf4bdcaded2308ae38abb6665cafa6bd36deba5c6ed2cb9"
    sha256 cellar: :any,                 arm64_big_sur:  "db4c52347be6860ebc237f49996a177b1706a89653d4891db5041cf6b9cc9951"
    sha256 cellar: :any,                 monterey:       "571d271187eb094a7b8ddee9e93fec77140042e279860b2ce6293d38bdaa1898"
    sha256 cellar: :any,                 big_sur:        "9e0cf46077fc1ef4e30377e9a1d6047f542f86796b7f0e30bd6f9be307c20a6b"
    sha256 cellar: :any,                 catalina:       "39d5bee8000fa0d133cb622b007cd050b2f1e7556a3f5e93d93ff2688abd6a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b74000aa583bff02c47f079b4c75940ea81803761256eda098132c0b74d369b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@1.1"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <strophe.h>
      #include <assert.h>

      int main(void) {
        xmpp_ctx_t *ctx;
        xmpp_log_t *log;

        xmpp_initialize();
        log = xmpp_get_default_logger(XMPP_LEVEL_DEBUG);
        assert(log);

        ctx = xmpp_ctx_new(NULL, log);
        assert(ctx);

        xmpp_ctx_free(ctx);
        xmpp_shutdown();
        return 0;
      }
    EOS
    flags = ["-I#{include}/", "-L#{lib}", "-lstrophe"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
