class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.5.0.tar.gz"
  sha256 "aab70aee10c134ef3fe568843fe4b3bb5e8901af30ea666f57462ad950682317"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "bec3490448e5bfab166597e1ba21643b11caddc285ddcc09fe72a423d4e2e3fb"
    sha256 cellar: :any,                 arm64_sonoma:  "18ae29440f9b633ce4e67e63d5b54131587facb18ee38ad222e6dbe6db21f441"
    sha256 cellar: :any,                 arm64_ventura: "78f145ea6c52f9474b1284d1cd5ae5ef87eb1879e7c38e118b58a1171dcaeec4"
    sha256 cellar: :any,                 sonoma:        "c940e4b76ff1f06c2a5850cf98f6b81436a9e2114658d3205500470c351d3ad8"
    sha256 cellar: :any,                 ventura:       "b41d0333a89ff7310e0b2ca93314c20cb49241e4fcf10f6a8f46418f420b8010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c87e0d6ed36859efb4486844c3fea80f6d6ca4970405e0e864e1e233bfee4e95"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "armadillo"
  depends_on "cereal"
  depends_on "ensmallen"

  resource "stb_image" do
    url "https://raw.githubusercontent.com/nothings/stb/0bc88af4de5fb022db643c2d8e549a0927749354/stb_image.h"
    version "2.29"
    sha256 "c54b15a689e6a1f32c75e2ec23afa442e3e0e37e894b73c1974d08679b20dd5c"
  end

  resource "stb_image_write" do
    url "https://raw.githubusercontent.com/nothings/stb/1ee679c/stb_image_write.h"
    version "1.16"
    sha256 "cbd5f0ad7a9cf4468affb36354a1d2338034f2c12473cf1a8e32053cb6914a05"
  end

  def install
    resources.each do |r|
      r.stage do
        (include/"stb").install "#{r.name}.h"
      end
    end

    args = %W[
      -DDEBUG=OFF
      -DPROFILE=OFF
      -DBUILD_TESTS=OFF
      -DUSE_OPENMP=OFF
      -DARMADILLO_INCLUDE_DIR=#{Formula["armadillo"].opt_include}
      -DENSMALLEN_INCLUDE_DIR=#{Formula["ensmallen"].opt_include}
      -DARMADILLO_LIBRARY=#{Formula["armadillo"].opt_lib/shared_library("libarmadillo")}
      -DSTB_IMAGE_INCLUDE_DIR=#{include/"stb"}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install Dir["doc/*"]
    (pkgshare/"tests").install "src/mlpack/tests/data" # Includes test data.
  end

  test do
    system bin/"mlpack_knn",
      "-r", "#{pkgshare}/tests/data/GroupLensSmall.csv",
      "-n", "neighbors.csv",
      "-d", "distances.csv",
      "-k", "5", "-v"

    (testpath/"test.cpp").write <<-EOS
      #include <mlpack/core.hpp>

      using namespace mlpack;

      int main(int argc, char** argv) {
        Log::Debug << "Compiled with debugging symbols." << std::endl;
        Log::Info << "Some test informational output." << std::endl;
        Log::Warn << "A false alarm!" << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-L#{lib}", "-o", "test"
    system "./test", "--verbose"
  end
end
