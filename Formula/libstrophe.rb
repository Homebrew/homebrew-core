class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.12.2.tar.gz"
  sha256 "049232e3968ad65c65e08601cb3de171d3a25d154b6f14332c35a7bf961e2c9d"
  license all_of: ["GPL-3.0-only", "MIT"]
  revision 1
  head "https://github.com/strophe/libstrophe.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2e4f7481a6fee674b2cd5d74c6d2fb1848b222106d59b56ac78bc88564e1d86"
    sha256 cellar: :any,                 arm64_monterey: "1091f61c3ad62fa4aebfb5658c5b9dcab1913d5c09514ecaef3477f4cd100d5a"
    sha256 cellar: :any,                 arm64_big_sur:  "5d0f77a6228c90b8740956c2f203293b0c1fb102676b2ef38b4dbae02f7c9795"
    sha256 cellar: :any,                 ventura:        "30c016a5fe015f25f60524d42ee6ef9630991f2baa1009d156ac2627b446d8fe"
    sha256 cellar: :any,                 monterey:       "b1163cbab169374c58ad0ff39796911c85dcb5b666681401afde209e9c72dd5e"
    sha256 cellar: :any,                 big_sur:        "d128f84cac8858210c28e52deef8eaf0f06a47e22617d2c521c573205269316e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ea4cff76b0c850862b56afc610d3721fbb3464e998652ac6689ec01148cc225"
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
