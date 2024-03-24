class Libpciaccess < Formula
  desc "Generic PCI access library"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/lib/libpciaccess-0.18.1.tar.xz"
  sha256 "4af43444b38adb5545d0ed1c2ce46d9608cc47b31c2387fc5181656765a6fa76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "515fa58b43a49a883ba9134cbab52845943485a6a338e7c8912dae72bd998952"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on :linux
  depends_on "zlib"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "pciaccess.h"
      int main(int argc, char* argv[]) {
        int pci_system_init(void);
        const struct pci_id_match *match;
        struct pci_device_iterator *iter;
        struct pci_device *dev;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpciaccess"
  end
end
