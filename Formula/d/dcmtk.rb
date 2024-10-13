class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk368/dcmtk-3.6.8.tar.gz"
  sha256 "232076655503138debf2f624109f1799e539354f186ce4e04b27cf82a9d8720f"
  license "BSD-3-Clause"
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url "https://dicom.offis.de/en/dcmtk/dcmtk-software-development/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "7acc30e4227a9bae7f135ea9e61eaaed861a28cb398831733550946b39584a3d"
    sha256 arm64_sonoma:   "b93d4799f022356c7ae4140f27f7aa2475dc81585ec595db1ef6d682a3dad3d0"
    sha256 arm64_ventura:  "395d941de382ca2a952d05d29ff5f9d4ff1aba7592c6fd1eb2f685f9129b34c1"
    sha256 arm64_monterey: "0856d56363ad7e76151ca34bb0622d929ad57c61d1af154a8a110ca50218a2ed"
    sha256 sonoma:         "2b4b9f0d6e1384949a48bb44c0ed1737268a5a71f9203889203cc524c5c59290"
    sha256 ventura:        "71cc77981eb068711f0135ac4c8d638a8fd11f12ed432482c57ad2ad9e7f7f5f"
    sha256 monterey:       "a43505eab9ca8ae07c7f36de7d56b00ec43cc7d9c4742beccecd5c697fbfe146"
    sha256 x86_64_linux:   "5c3fffbfab9d12f16836c40a46b5080f633049ec2c4e43d2079a97b75e85d1bb"
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
