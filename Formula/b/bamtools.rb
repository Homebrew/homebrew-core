class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  url "https://github.com/pezmaster31/bamtools/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "7d4e59bac7c03bde488fe43e533692f78b5325a097328785ec31373ffac08344"
  license "MIT"
  revision 1
  head "https://github.com/pezmaster31/bamtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8e8d1b1517af38c77262824988729d08207aa2cbd2b4c4dbabaec811a512081"
    sha256 cellar: :any,                 arm64_sequoia: "d2d039c52afcc2619c964a259c7ec509f88d91ac86db3be4b60b0e2e214afe18"
    sha256 cellar: :any,                 arm64_sonoma:  "2e15c688f92ca708cb3c291a9e60003dd8e68e9c6e1becbe6a253098b5292a79"
    sha256 cellar: :any,                 sonoma:        "4515350fae1a4dc6e96a85e0fbe9aabd09725a6cdeba153958f7ec4a9f8635d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c76377b22b8eb2db52870a018989b2fd339c2d0e55500238657e7427a5b9c8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "542d3eff5a4e76c2c8c00183e5e8d0f1934296c94540a200f923f095ef41549c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jsoncpp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
