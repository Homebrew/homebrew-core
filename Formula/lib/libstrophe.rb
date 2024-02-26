class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/refs/tags/0.13.1.tar.gz"
  sha256 "0268509f150d72ef63e830db9e6f0d4ecff9727ee0976ffb99a6feb6eb4100c7"
  license all_of: ["GPL-3.0-only", "MIT"]
  head "https://github.com/strophe/libstrophe.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "902dcba315b0ce926f99a15f5f7dc0ac802a13a24dee1f5e1492af9bc65e12ae"
    sha256 cellar: :any,                 arm64_ventura:  "923cf6f7907fe086f31956910790a9585f643b11566b4a832f8e31bd3fc5b85c"
    sha256 cellar: :any,                 arm64_monterey: "fdcba4273478eed63187409bde68ee5027126ff9b3a77d79547c143e06a016e4"
    sha256 cellar: :any,                 sonoma:         "0278227c427a15ad1800483c3fbdf5f80d4d10583d0744819c3780e0bb445d44"
    sha256 cellar: :any,                 ventura:        "278baea5795453581e16ec35f9b682de22b7e4d61e8b73a35fba051925f3399d"
    sha256 cellar: :any,                 monterey:       "83fafe1791afdbd3927816fd63ebd253519e99b6995da87048656eac8962b157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36117cdb479c36a81b0afdb0264664fdc77dbd3a79ccced9234b39a6298fd45f"
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
