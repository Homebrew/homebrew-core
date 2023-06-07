class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk367/dcmtk-3.6.7.tar.gz"
  sha256 "7c58298e3e8d60232ee6fc8408cfadd14463cc11a3c4ca4c59af5988c7e9710a"
  revision 1
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url "https://dicom.offis.de/en/dcmtk/dcmtk-software-development/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "56304c047bdb463854f71556209410992b5f252fd0f0f33b1cefead035e27793"
    sha256 arm64_monterey: "c966591af19a169366159a0627b43bcae6b5c90b8efcffa2259ffd093e8f405e"
    sha256 arm64_big_sur:  "3f689f24e0cf1573b561e08373941648f65ecc8cffc4606b9a2777c2670e4006"
    sha256 ventura:        "a0874415414b69e964b2edd63b07b0fad5220b96e2eaff5ad82ef72403989047"
    sha256 monterey:       "f0cf38165223c381b0d88d273d354ca87d5f834b415ace05e5c9bc7264fe0ab8"
    sha256 big_sur:        "44385222676a716e78524f80ce61b155d257bee41a8853b2cbdca52f843ba941"
    sha256 x86_64_linux:   "6ae6be2c9ffcf1a438ace27a6d22e08fe953c82ef830b198eaf6f1c2f39a365c"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

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
