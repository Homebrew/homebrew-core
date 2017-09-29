class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.5.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.5.orig.tar.gz"
  sha256 "d13df67f5402c1905d2c24603471fe783965112ab5004025a50f7f852cd89bc8"

  bottle do
    cellar :any
    sha256 "51efc9ca593a11cc377963826d957b1bbca72b77b15af07dd66ad5487abaca73" => :high_sierra
    sha256 "35defd469fb53a863b8983ed78f988780c11ff96de7724190c4947a75750efab" => :sierra
    sha256 "36b814cb280fd1aecee057187f07f307fc80a643c71b1f8d61339375f1dbeea0" => :el_capitan
  end

  def install
    system "make", "NO_PYTHON=1"
    system "make", "NO_PYTHON=1", "DESTDIR=#{prefix}", "PREFIX=", "install"
    mv lib/"libfdt.dylib.1", lib/"libfdt.1.dylib"
  end

  test do
    (testpath/"test.dts").write <<-EOS.undent
      /dts-v1/;
      / {
      };
    EOS
    system "#{bin}/dtc", "test.dts"
  end
end
