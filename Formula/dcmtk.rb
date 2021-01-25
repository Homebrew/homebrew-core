class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk365/dcmtk-3.6.5.tar.gz"
  sha256 "a05178665f21896dbb0974106dba1ad144975414abd760b4cf8f5cc979f9beb9"
  revision 1
  head "https://git.dcmtk.org/dcmtk.git"

  livecheck do
    url "https://dicom.offis.de/download/dcmtk/release/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "a52a1b60a406463246b8eb194e25589c88dfa982a936560bf6948be569448833" => :big_sur
    sha256 "a86027494ff074de767cef1a7bf31639e50f153d4a2ec5297bb9560bb3e48ef6" => :catalina
    sha256 "2bbb1bf5d51c7e12c2db901a632862b9429ef2b146f973feda5212fb1391ac33" => :mojave
    sha256 "352137e82f70183e543b6d532dcf67c7fa95ea67b63421ad4fc9c0a0f19ba484" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      system "cmake", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args, ".."
      system "make", "install"
      system "cmake", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args, ".."
      system "make", "install"
    end
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end
