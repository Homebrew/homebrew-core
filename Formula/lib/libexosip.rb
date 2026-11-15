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
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "2d36e210652e3d69b74813ca3df06b03b4cd4a31734fd1026e066d9bba213ea4"
    sha256 cellar: :any, arm64_tahoe:       "fd656403b8e8d5437cb745a7bdd4361a91e7d2189f047feb8fc666e2986ea6d8"
    sha256 cellar: :any, arm64_sequoia:     "5ef1ade494065b22d7fad22c10f08cba832b76773fca7de7bae22661f13af8df"
    sha256 cellar: :any, arm64_linux:       "652d6f38ba6fb236578ddc94d3d8188d682a791b1a5c89719f72140b80d5c830"
    sha256 cellar: :any, x86_64_linux:      "045476fc48b507eaa2ac61574dd617897df6a8682057b82ceaabd1b65cf20457"
  end

  depends_on "pkgconf" => :build
  depends_on "c-ares"
  depends_on "libosip"
  depends_on "openssl@4"

  allow_network_access! :test

  def install
    # Extra linker flags are needed to build this on macOS. See:
    # https://growingshoot.blogspot.com/2013/02/manually-install-osip-and-exosip-as.html
    # Upstream bug ticket: https://savannah.nongnu.org/bugs/index.php?45079
    if OS.mac?
      ENV.append "LDFLAGS", "-framework CoreFoundation -framework CoreServices " \
                            "-framework Security"
    end
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-leXosip2", "-o", "test"
    system "./test"
  end
end
