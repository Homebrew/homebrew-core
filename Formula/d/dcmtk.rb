class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk369/dcmtk-3.6.9.tar.gz"
  sha256 "b93ff5561244916a6e1e7e3ecccf2e26e6932c4edb5961268401cea7d4ab9c16"
  license "BSD-3-Clause"
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url "https://dicom.offis.de/en/dcmtk/dcmtk-software-development/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "6349ba68f65ba257caa778ea8ab86fbf2b70141baf5a0a8f7bfa3759765c42a8"
    sha256 arm64_sonoma:  "86d3578d795ba30a2a75a9c3d5fa8c5f692bc54c38ed5c2a901cdd10c8e15023"
    sha256 arm64_ventura: "fd350d43be22126a196b194747b45df08b58919507fd61bde058c153a97ccf33"
    sha256 sonoma:        "b5496a75247e5fd852d750a503dc788829bcc3e9532a90fae42d64508bf72ba6"
    sha256 ventura:       "acaae376685ecc370ccf3f6b363b6c1d8b1ace7f752999103eb01eaf44e4716a"
    sha256 arm64_linux:   "daba3c30c6cf392a687cc367de332af8ff31c125542b6c474349b2b7c9ad5277"
    sha256 x86_64_linux:  "bf2a2675135b64915b5c5b427c536289e68a904007d0d0ef0c999845005aae14"
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
