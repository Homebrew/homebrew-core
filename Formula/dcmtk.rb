class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  revision 1
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  stable do
    url "https://dicom.offis.de/download/dcmtk/dcmtk366/dcmtk-3.6.6.tar.gz"
    sha256 "6859c62b290ee55677093cccfd6029c04186d91cf99c7642ae43627387f3458e"

    # Fix build for Apple Silicon.
    # Issue ref: https://support.dcmtk.org/redmine/issues/957
    # TODO: Remove in the next release along with stable block
    patch do
      url "https://git.dcmtk.org/?p=dcmtk.git;a=patch;h=5fba853b6f7c13b02bed28bd9f7d3f450e4c72bb"
      sha256 "533cfe46414f6c76dcdf56fd9633a399f813707a0cb8fe2630126cbd747134c8"
    end
  end

  livecheck do
    url "https://dicom.offis.de/download/dcmtk/release/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "af4f35155aace775c3197d5416febad1a572fb4ec9effed366dfa40f168cd068"
    sha256 arm64_big_sur:  "c4b179784469710ef3f374bad804b7d23fe30ecaa9dabafc6d70b12e2e53cad0"
    sha256 monterey:       "4f09e9db0bc9b614c7e02f813d34cde52714ba02eebfbe483167b6a19f81b3d8"
    sha256 big_sur:        "21cab34f724d1178460d76fdcecc4e9887252900a29a6398b87a1dea48eecef8"
    sha256 catalina:       "b38229590ce4674748023c33e4a84d3b96f52ee97351722ccbd49228f15330bb"
    sha256 x86_64_linux:   "1fe19565fb6d8722f357ecc7e9ffc1534be0778787fc7066ad7fd9cc8f890651"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  def install
    ENV.cxx11 if OS.linux? # due to `icu4c` dependency in `libxml2`
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
