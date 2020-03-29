class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk365/dcmtk-3.6.5.tar.gz"
  sha256 "a05178665f21896dbb0974106dba1ad144975414abd760b4cf8f5cc979f9beb9"
  head "https://git.dcmtk.org/dcmtk.git"

  bottle do
    sha256 "5b49e8b8d34cd1472f5091fc4d6e4b4a05133ac3cd85f6f428aef6c1013234b0" => :catalina
    sha256 "3d149b4aa7f6d76df7ddda09d845c4c43a0aa0617800b9ea25602183e213f5b0" => :mojave
    sha256 "70ba2b42c6a522f2da68ac47834f240db316afd12b388edb4bc7c1f586a18f2c" => :high_sierra
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
