class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk367/dcmtk-3.6.7.tar.gz"
  sha256 "7c58298e3e8d60232ee6fc8408cfadd14463cc11a3c4ca4c59af5988c7e9710a"
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url "https://dicom.offis.de/en/dcmtk/dcmtk-software-development/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "805f52eeba91d0172e8ed683b3de11ad4e73beecb5c920fb11398865870c2b0b"
    sha256 arm64_monterey: "565fbd4791b791742003351d4ecae98be11cc4f275a57878f091e6bb515919f9"
    sha256 arm64_big_sur:  "5741131292a6166f82c63315df61f9c36e4f4ffbc65bebdea40596800606ff93"
    sha256 ventura:        "a446481184f15e119a67f2c5b931bf19caf9c696d2ea9965fc0044ddde75f20f"
    sha256 monterey:       "df14ac2121da42c2a3cf7a58772c95ceaf8fde5e891b822ccd34267060dab14e"
    sha256 big_sur:        "f1f870f1cc726934826df5edbc3687cb3d4b4ed9c464bc0c3ddf5922ba5d5380"
    sha256 x86_64_linux:   "e44445d8fb07d33bf0c979c44a8d17cd82cca337be63a01d58d438bf28dd34ea"
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
