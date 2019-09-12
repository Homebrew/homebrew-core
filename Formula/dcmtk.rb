class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk364/dcmtk-3.6.4.tar.gz"
  sha256 "a93ff354fae091689a0740a1000cde7d4378fdf733aef9287a70d7091efa42c0"
  revision 1
  head "https://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "d7c5cbc32fdd0c44228884512eb0cf8068d6b169165a822f6c57e61cb7d40bce" => :mojave
    sha256 "c8be648beb4178829963b0029153f6d0ab1be921a9cd472760e661b98f17d94e" => :high_sierra
    sha256 "292276fd0f5f5a8c0782e6e5fc0d35895600c9835ff634f7b16e6b92e534f72b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@1.1"
  uses_from_macos "libxml2"

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
