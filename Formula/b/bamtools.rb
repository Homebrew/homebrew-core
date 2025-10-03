class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  url "https://github.com/pezmaster31/bamtools/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "7d4e59bac7c03bde488fe43e533692f78b5325a097328785ec31373ffac08344"
  license "MIT"
  head "https://github.com/pezmaster31/bamtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de2b4d556e28fa243f1ffed7caa5a587d02a6ea23bfd11e9b977d6c4808c57d2"
    sha256 cellar: :any,                 arm64_sequoia: "3373086bf64dc373555ebe29e0d83b7717e9753c2568f6e28aa1bda00f03c8cc"
    sha256 cellar: :any,                 arm64_sonoma:  "1bb2f639770d64612d2a90faf8409396a4ca9c8d07ac57c49ea34605110cb8e9"
    sha256 cellar: :any,                 arm64_ventura: "f3ba5ba2ba5277012456cfbcfb26c4dbd7a1a5c7d5eb59034ff0ec3d10b08409"
    sha256 cellar: :any,                 sonoma:        "d47d47a532624911149aeed6ce5f3774d040bc589c188f8699f43025920ac3d6"
    sha256 cellar: :any,                 ventura:       "1b1ed182544cc5cb37a5706c1246f4bf0df3f14bf199ebc2c46c60e55e40f7a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc7464d2e563ff3573d4d1754e543ce554efc1af87cd361301e65b7ca0d3b0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1338babe6eccee20e6d23f405db8267025fe19f221e0ddd9d7cb2cd02654c48"
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
