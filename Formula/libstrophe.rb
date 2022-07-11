class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.12.1.tar.gz"
  sha256 "91fc40a89528a32b0bda975d84f8f567b57e687898e22e328b3733c2ae0393d8"
  license all_of: ["GPL-3.0-only", "MIT"]
  head "https://github.com/strophe/libstrophe.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7702d22629c361046b0d84a19e147af2e151363094005b12be107e4e965f0af4"
    sha256 cellar: :any,                 arm64_big_sur:  "25ffc119bb9d032914b985500f4519d53caa4787277641ca61c43f981ac43787"
    sha256 cellar: :any,                 monterey:       "653b83b209534a2d182625a1760107d17c935c72a36bcf22241a62389672403e"
    sha256 cellar: :any,                 big_sur:        "4654a334efb488f4697937a8be71ea095f850e5b4c8bb0ba9321059328cd365f"
    sha256 cellar: :any,                 catalina:       "bae7c561aa6a40a934b08811e472b7ba41e001a086df01f2db86f75319d53062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11b5a557fe453c15714aca89678954a7937092f35de3cad4e74fca6ddd884b22"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
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
