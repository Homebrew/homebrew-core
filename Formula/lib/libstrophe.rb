class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/refs/tags/0.13.0.tar.gz"
  sha256 "c1e3cc7c728c2d793a8799b29208439495b65bdedc6732d855fe54c3a1fc13c8"
  license all_of: ["GPL-3.0-only", "MIT"]
  head "https://github.com/strophe/libstrophe.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "51b09df6c3b36215c85157fa8f82955abc4ebaba4c6d055b9028247d87189c1c"
    sha256 cellar: :any,                 arm64_ventura:  "6242c2423d809c91e92af6740a0bc0c3a645b1d8f7b53c16ac80ad7ced5109f5"
    sha256 cellar: :any,                 arm64_monterey: "abd1960e1a2c11376b193a2f05bcd2837c23353a55a93ea7a658c079a335e1fa"
    sha256 cellar: :any,                 arm64_big_sur:  "3bbbc656139c356d7baabc785251f8228c3b2ce2bbe87198310aaf007ed1835d"
    sha256 cellar: :any,                 sonoma:         "a7845766858de6baa054503d1c2d87d72442cf55965eabc4f0593bc50a7a3f39"
    sha256 cellar: :any,                 ventura:        "9186c1d767ce39e292382f2834908d6ff100cd86ee3ea1814c66fe764b77f50b"
    sha256 cellar: :any,                 monterey:       "1a52e120aa045efede48f79a89bc50206bc471932d2e4ef4e3ceafa28fee1f67"
    sha256 cellar: :any,                 big_sur:        "1c8006b2714f09bc5048189116cb1c2bc858a28fce5020c490a3dea54ff8125f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc9d50b657e06f5dc3c251aa5fcad01fcdc8ab8b499e6df52ec0c043611ca5d3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

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
