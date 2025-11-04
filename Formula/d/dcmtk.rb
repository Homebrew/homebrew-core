class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk369/dcmtk-3.6.9.tar.gz"
  sha256 "b93ff5561244916a6e1e7e3ecccf2e26e6932c4edb5961268401cea7d4ab9c16"
  license "BSD-3-Clause"
  revision 1
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url "https://dicom.offis.de/en/dcmtk/dcmtk-software-development/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "76dc8240010bf2c6acf90a08fda3b77c4776ffa192f06b12aa838074529c66a4"
    sha256 arm64_sequoia: "f160534389aad829b4683786aff6bedddef73682920c2f014a6783b3fe3fcd6f"
    sha256 arm64_sonoma:  "fbc50e817048baf3356e3d6b86c1ec6142fd55dc414daa1e59ab95f352e5d2ab"
    sha256 sonoma:        "3f54b37d96f4595a543c7d9a4ebcac52ef09664f1cf2588838efae58d072fcc1"
    sha256 arm64_linux:   "2fb17aba6d6db1e13d85ac282f2085d5daa7af3cc4d6d21d8f549563493a7f98"
    sha256 x86_64_linux:  "f00223f0ae751c365c1bc3d4ec4a2bdbfe2ab13dee4fb9b57bbfaae97a36375d"
  end

  depends_on "cmake" => :build

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args + ["-DDCMTK_WITH_ICU=OFF"]

    system "cmake", "-S", ".", "-B", "build/shared", *args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args,
                    "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/*.a"]

    inreplace lib/"cmake/dcmtk/DCMTKConfig.cmake", "#{Superenv.shims_path}/", ""
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end
