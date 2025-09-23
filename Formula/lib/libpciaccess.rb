class Libpciaccess < Formula
  desc "Generic PCI access library"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/lib/libpciaccess-0.18.1.tar.xz"
  sha256 "4af43444b38adb5545d0ed1c2ce46d9608cc47b31c2387fc5181656765a6fa76"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_linux:  "a8fb19ee3879959b844dd4ba0d79850dbaf58d99863aaafc74ce099165ff49fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3433b90a4f960f70e9203327f632387b5ada5017be2500ab8098f9142406a075"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on :linux
  depends_on "zlib"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "pciaccess.h"
      int main(int argc, char* argv[]) {
        int pci_system_init(void);
        const struct pci_id_match *match;
        struct pci_device_iterator *iter;
        struct pci_device *dev;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpciaccess"
  end
end
