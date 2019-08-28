class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk364/dcmtk-3.6.4.tar.gz"
  sha256 "a93ff354fae091689a0740a1000cde7d4378fdf733aef9287a70d7091efa42c0"
  revision 1
  head "https://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "46d767ca45268ce74114db9d9593e28acd17ac31ffb055c00653702f11795102" => :mojave
    sha256 "322ad228d11c068ddab0ce532106aeddfbebd6019c433a918d3ee90eb53d7bee" => :high_sierra
    sha256 "09ed452dbde3f7eae5233d475a1bbf07824505773729dcc55f6f00b90378d8fd" => :sierra
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
