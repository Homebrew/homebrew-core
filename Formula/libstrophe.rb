class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.12.0.tar.gz"
  sha256 "f645819d8d93711c92454974dd9007c9b9e98ea0b59cb708dc626dd4c6b9d0a8"
  license any_of: ["GPL-3.0", "MIT"]
  head "https://github.com/strophe/libstrophe.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "37d082b37338686b1ebae289da1cd4b3e989dc029899a1683a51e581ef5c5193"
    sha256 cellar: :any,                 arm64_big_sur:  "1566e3b3fdb49be1fffc526fe93a7e5a7bf77b75b71c6588ebd4400f7b250a29"
    sha256 cellar: :any,                 monterey:       "c33fd8b6bba0f9dc4bde68cfb05eb844123e9cc0f27688b3943af5ee7f9ab71c"
    sha256 cellar: :any,                 big_sur:        "4eaa47a2b6f35d8867ee63c1575cb8ce093e6a0266e2b08688b2c9447d3240aa"
    sha256 cellar: :any,                 catalina:       "6e0877ea21878ce6eceb361fd7e00391300ef1881d6ef98497e3c46fd8dc4ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7d50a1d3246972a879066ae41af5204a2c57d40bb1ad93f4321d18bd4b1db2d"
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
