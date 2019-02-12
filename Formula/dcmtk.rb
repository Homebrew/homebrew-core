class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk364/dcmtk-3.6.4.tar.gz"
  sha256 "a93ff354fae091689a0740a1000cde7d4378fdf733aef9287a70d7091efa42c0"
  head "https://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "cf1f1557cbb1842de688bc31128a98e059cddad80e9265d1244129f838ae60d8" => :mojave
    sha256 "ebc1492ba0b008c2d84e84cce1be2da9eb9210ffa8809bcfc710a0bcf35d5575" => :high_sierra
    sha256 "c7771b2deb50e919f2b332d532f7f81bd67331a2350aea85f7f61658a70b5b15" => :sierra
    sha256 "586903834cdc7bbc4ffc7adb5478b63fb80df1f95b1a631a8b41d5b54bbc275f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make", "install"
    end
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end
