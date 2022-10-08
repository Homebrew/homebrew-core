class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk367/dcmtk-3.6.7.tar.gz"
  sha256 "7c58298e3e8d60232ee6fc8408cfadd14463cc11a3c4ca4c59af5988c7e9710a"
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url "https://dicom.offis.de/download/dcmtk/release/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f203412cec4eb400615ac2848f2c5b69fd71646f247dd5b9e56dd9599d2267b7"
    sha256 arm64_big_sur:  "37339a0e0df51bc216fd468999b2237da7504811d896f7b07f1aeb4a1c56e7d6"
    sha256 monterey:       "e0f4cc646793500166589dfc9a49f0844952274d577f24f5f92811d89e57d83e"
    sha256 big_sur:        "a3b37c92e50f83c07b5f4b8c8738927c4fd8074721cbe717adde6ef3cc74e49b"
    sha256 catalina:       "a38a36ffc1c0a620a8a4c7e2e49794528c31d35333cf007e4f0a72bdeb624bb8"
    sha256 x86_64_linux:   "9adb7099d18838ded48e5aa4cb7be585c609fdc723ee8f9bb3bfdb804de5e1a0"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args,
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
