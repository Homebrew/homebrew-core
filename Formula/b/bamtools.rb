class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  url "https://github.com/pezmaster31/bamtools/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "7d4e59bac7c03bde488fe43e533692f78b5325a097328785ec31373ffac08344"
  license "MIT"
  head "https://github.com/pezmaster31/bamtools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7f678e35ee8bbd84f50d0bc33a6ebeb840754b2581599be380d6bbd823f9b70e"
    sha256 cellar: :any,                 arm64_sequoia: "b0af491c561150a59e610140388f05e9d61eaac14806f6e1aee5069413b4c2c7"
    sha256 cellar: :any,                 arm64_sonoma:  "7a331a56657ba146a719fbe8911bb43e7b9155c824a6c4f33ecc88931800a53e"
    sha256 cellar: :any,                 sonoma:        "83b46fc21dd8d03010235b022abe2d98bff4219707b5ff6fbad3c7735609286f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0575567ce67f57826e323b0f26aa06f5b0d4f23db128c45b659bd4f1243fd903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "464bbce0fe1f5f7e302f4274e4e5bfb1153083f95b7e5d754b70690b8cc0748a"
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
