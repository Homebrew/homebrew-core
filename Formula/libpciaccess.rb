class Libpciaccess < Formula
  desc "Generic PCI access library"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/lib/libpciaccess-0.17.tar.gz"
  sha256 "bf6985a77d2ecb00e2c79da3edfb26b909178ffca3f2e9d14ed0620259ab733b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6ea67393c5a32066f823858c124136a6b0e296fb033321c7bb073a618c65d2b9"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on :linux

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
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
