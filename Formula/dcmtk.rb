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
    sha256 arm64_ventura:  "68be02a32bb3b8e2443ddadb18294112eef1be54a9252e001b5382a7ae82c9ae"
    sha256 arm64_monterey: "59ed5979c3b6334f91a602b2454e32f8edd3366da9d65ede175c0c46d2f72454"
    sha256 arm64_big_sur:  "00a5b4dd4f3bcd730c25bfac071674217cc69a741ebbf63fe3642825515b8468"
    sha256 ventura:        "9338fb134d6234f631014a7e61cfcfeedede42d536355dd84147af626448ee79"
    sha256 monterey:       "3754b8a93a9dad1dcf6af2f63076d5256541b7d38bb15a779683283ce2b68be0"
    sha256 big_sur:        "3f7866805a74f6d11600ee320e075811325e406e8d56f5725494a64310d484f9"
    sha256 catalina:       "d7d97969b9c88c913f9e36f17a9069d27ba7c9b19d08b54885b9f3381cc362dd"
    sha256 x86_64_linux:   "648a5f4514ae6a70061493c43904eb6c699fe954a6fa99547c855223a2af05fe"
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
