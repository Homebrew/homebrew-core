class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk366/dcmtk-3.6.6.tar.gz"
  sha256 "6859c62b290ee55677093cccfd6029c04186d91cf99c7642ae43627387f3458e"
  head "https://git.dcmtk.org/dcmtk.git"

  livecheck do
    url "https://dicom.offis.de/download/dcmtk/release/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 monterey:     "1dc612a4f94de16b6d967b0d7bfddbd887524a38b660d6be77900f74927d5dc8"
    sha256 big_sur:      "14f0ad1188c09414ce0c38a5b1daad58031c490dedcb0e602d3a9d8946a7513c"
    sha256 catalina:     "b7169841e5ae53c3641392130e2d72190a859eb566e0445d16f58131a0bfe34a"
    sha256 mojave:       "ba2af245944fd723362c4fd758aaa90a9f3b651e3422ce1326078bcdc4cad093"
    sha256 x86_64_linux: "b7835228c2d0f5a9fb9a87970d75b34415f1629e24ee0c10dc953722595163af"
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

      inreplace lib/"cmake/dcmtk/DCMTKConfig.cmake", Superenv.shims_path, ""
    end
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end
