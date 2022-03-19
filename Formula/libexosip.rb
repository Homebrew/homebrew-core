class Libexosip < Formula
  desc "Toolkit for eXosip2"
  homepage "https://savannah.nongnu.org/projects/exosip"
  url "https://download.savannah.gnu.org/releases/exosip/libexosip2-5.3.0.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/exosip/libexosip2-5.3.0.tar.gz"
  sha256 "5b7823986431ea5cedc9f095d6964ace966f093b2ae7d0b08404788bfcebc9c2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/exosip/"
    regex(/href=.*?libexosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f25383f6e18e92d09bea5ce9a5355de38897736a00a1b5b73198f093e9f0302e"
    sha256 cellar: :any, arm64_big_sur:  "e5862acc819d00bfe377cb07242481b6bf0749c358eb3d7e3523a22efa05b893"
    sha256 cellar: :any, monterey:       "15e973aa1ca096bd2f5120d2fc9a99549eef1349e73d44225370f47ddb1e3e5b"
    sha256 cellar: :any, big_sur:        "5a9c2568c86ffd96558f1d3c30dba6b088db674016df2ca5a70b265309108e59"
    sha256 cellar: :any, catalina:       "f5afd5d2f0a37b824d6d054eaceae651c8b91484f0e8ca7f501c04f52e4daee6"
  end

  depends_on "pkg-config" => :build
  depends_on "c-ares"
  depends_on "libosip"
  depends_on "openssl@1.1"

  def install
    # Extra linker flags are needed to build this on macOS. See:
    # https://growingshoot.blogspot.com/2013/02/manually-install-osip-and-exosip-as.html
    # Upstream bug ticket: https://savannah.nongnu.org/bugs/index.php?45079
    if OS.mac?
      ENV.append "LDFLAGS", "-framework CoreFoundation -framework CoreServices "\
                            "-framework Security"
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <netinet/in.h>
      #include <eXosip2/eXosip.h>

      int main() {
          struct eXosip_t *ctx;
          int i;
          int port = 35060;

          ctx = eXosip_malloc();
          if (ctx == NULL)
              return -1;

          i = eXosip_init(ctx);
          if (i != 0)
              return -1;

          i = eXosip_listen_addr(ctx, IPPROTO_UDP, NULL, port, AF_INET, 0);
          if (i != 0) {
              eXosip_quit(ctx);
              fprintf(stderr, "could not initialize transport layer\\n");
              return -1;
          }

          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-leXosip2", "-o", "test"
    system "./test"
  end
end
