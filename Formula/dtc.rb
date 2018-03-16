class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://www.kernel.org/pub/software/utils/dtc/dtc-1.4.6.tar.xz"
  sha256 "382302bfcc3c40734be80ac620983971d911ec4cde798f551873f3eb008c7b7e"

  bottle do
    cellar :any
    sha256 "8b2e6b7f837522b3459f5a9a32fca23427868172100ee01cb8373e38ceff8cf3" => :high_sierra
    sha256 "e34cbf3f0024346a9577249ec392f8a16576c356d74d3a96569b3e871a6eb514" => :sierra
    sha256 "e1cc9f8201d537386c6d4ac3e68aaea9328cdbcd4f912c21c98d1a2fd1e17336" => :el_capitan
  end

  def install
    system "make", "NO_PYTHON=1"
    system "make", "NO_PYTHON=1", "DESTDIR=#{prefix}", "PREFIX=", "install"
    mv lib/"libfdt.dylib.1", lib/"libfdt.1.dylib"
  end

  test do
    (testpath/"test.dts").write <<~EOS
      /dts-v1/;
      / {
      };
    EOS
    system "#{bin}/dtc", "test.dts"
  end
end
