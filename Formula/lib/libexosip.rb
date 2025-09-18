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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "65ae132c14b0b6e7928dacd91669bf489bf089b1cdcee75612ab52a2c6dc5363"
    sha256 cellar: :any,                 arm64_sequoia:  "642cdbf3c7e2c28d59ba0bfa578465767fcc52a0640153ae68efea87e928243a"
    sha256 cellar: :any,                 arm64_sonoma:   "4fc704e8d56094e3cae0b85da0ef283821679c52d11376eab270a5532b75e7e8"
    sha256 cellar: :any,                 arm64_ventura:  "f16e7871375ba4b6fa1a0449efdbaac6cd0ecd385cb30ca73b81e5303b4fe643"
    sha256 cellar: :any,                 arm64_monterey: "986de480122d68131d838a6f0d37921978491b83e01fc53ab8631c50ce428cf0"
    sha256 cellar: :any,                 arm64_big_sur:  "54df18bb3bea9dca975b830312f28ac7510dadb108db9053a3eafdf8481add0b"
    sha256 cellar: :any,                 sonoma:         "63dc5332096f15cfab981171841ea55a5462cfdfe779bd750c5c5f470169ff7a"
    sha256 cellar: :any,                 ventura:        "836deee9270859281bfb13c2b75d44cad2e6d2f38a2a99490c086b749f45258e"
    sha256 cellar: :any,                 monterey:       "a3ffa4272cd49779d2ba780252af1a9e9bc56d30dae6e1b757bdd449e7c47221"
    sha256 cellar: :any,                 big_sur:        "7af6a64fb918f2ddc565947e49f911520f7340f8ddf09cb23a28aad2e4be35cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f2248230c56cae9643494c59e8b62ed822cabc1dc5fc1013b98efbf608bad015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07fe4531bd26a4c6fabb8833e55dc9b955c3f995c5c024177b9a9e3800785782"
  end

  depends_on "pkgconf" => :build
  depends_on "c-ares"
  depends_on "libosip"
  depends_on "openssl@3"

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
