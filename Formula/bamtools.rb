class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  url "https://github.com/pezmaster31/bamtools/archive/v2.5.2.tar.gz"
  sha256 "4d8b84bd07b673d0ed41031348f10ca98dd6fa6a4460f9b9668d6f1d4084dfc8"
  license "MIT"
  revision 1
  head "https://github.com/pezmaster31/bamtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58ddd12242c381fcae63a5142e1af12954965f1d4bf443c25a270fc35d5eba2d"
    sha256 cellar: :any,                 arm64_monterey: "fd3594b78acee23bf5d260ecb30dbcc32a6c51f2c57b02fcd46f6bf6e0215741"
    sha256 cellar: :any,                 arm64_big_sur:  "a09703edb44ac45c00f1ca338736af291def439419edf571500dfec776d7c71f"
    sha256 cellar: :any,                 ventura:        "b4066241fe612379ed5ef3086f50735d4fc3217fb8e171e04e9b4491766022f2"
    sha256 cellar: :any,                 monterey:       "d81c6addc556c9d421e8a6974c3ae564c0de8291d64d0d9476dafe2cd9c8e5f0"
    sha256 cellar: :any,                 big_sur:        "ae4c20d973c8ed46a430c668bcbc2b6ac4c32a9241bd989bf8c3afe3cc0f57da"
    sha256 cellar: :any,                 catalina:       "4bd0d24b3301ba788bc79cdf12f07dbf499347dce3beb9250e7ec6e12b6670a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5909b02859753489fe8e24652053afdca942f6d88b13f110a0d04650478c81a9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jsoncpp"

  uses_from_macos "zlib"

  def install
    # Delete bundled jsoncpp to avoid fallback
    (buildpath/"src/third_party/jsoncpp").rmtree

    # Build shared library
    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Build static library
    system "cmake", "-S", ".", "-B", "build_static", *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_static/src/libbamtools.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "api/BamWriter.h"
      using namespace BamTools;
      int main() {
        BamWriter writer;
        writer.Close();
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/bamtools", "-L#{lib}",
                    "-lbamtools", "-lz", "-o", "test"
    system "./test"
  end
end
