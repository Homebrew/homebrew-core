class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  url "https://github.com/pezmaster31/bamtools/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "4d8b84bd07b673d0ed41031348f10ca98dd6fa6a4460f9b9668d6f1d4084dfc8"
  license "MIT"
  revision 2
  head "https://github.com/pezmaster31/bamtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "195840857da6e5e0c020ce41c66ad701845977133164ad6717fcde1bc7484ef6"
    sha256 cellar: :any,                 arm64_sonoma:  "27089259ae4ea2993a81c7e635b5fbdd37a9e21623ace3dba86a75d967bf3ab3"
    sha256 cellar: :any,                 arm64_ventura: "0104d42510158aced69f6108ab3de5c363e32ca9fc4b6eec8acb7f3858d3f5d7"
    sha256 cellar: :any,                 sonoma:        "aa7b96819c55b2e59c375501932eee2e32d091bc64b9a5be8cdad68c18a071b3"
    sha256 cellar: :any,                 ventura:       "90df0038551d0a60a82e5f9b43438d5e7731bbeb2a73f0054fe79fb9c97c594c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc024aec0c01995edd1a1a0450cc4dd94d05498b22dd5a1ec7b600c3e118b32a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "696b432ed15581f9ddc4dd262c03e0b7cdee1ba19b387a86f10e88650740fbf0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jsoncpp"

  uses_from_macos "zlib"

  def install
    # Delete bundled jsoncpp to avoid fallback
    rm_r(buildpath/"src/third_party/jsoncpp")

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
    (testpath/"test.cpp").write <<~CPP
      #include "api/BamWriter.h"
      using namespace BamTools;
      int main() {
        BamWriter writer;
        writer.Close();
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}/bamtools", "-L#{lib}",
                    "-lbamtools", "-lz", "-o", "test"
    system "./test"
  end
end
