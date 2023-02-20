class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.0.1.tar.gz"
  sha256 "4c746936ed9da9f16744240ed7b9f2815d3abb90c904071a1d1a628a9bbfb3a5"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  revision 1
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "995a00364fb60be3312aef995709240af153cc59b0845a0dffc74d0650f5e563"
    sha256 cellar: :any,                 arm64_monterey: "30cf5ba4558baea34744e128d77bea54a1b4e0c53d7761fb6b83de578b6b1d2f"
    sha256 cellar: :any,                 arm64_big_sur:  "774d1218866a46e46cf7c57cf5587745ed692c207b854d22b69f833bed78a79d"
    sha256 cellar: :any,                 ventura:        "e6fc92e0b0741393ed7a3f7cf3fd9f18ee6e9e2871165a8695367786c4cfb97a"
    sha256 cellar: :any,                 monterey:       "6c7fcb29876984333188a9d59842d512bd324def5fabf694570510583b174e6a"
    sha256 cellar: :any,                 big_sur:        "79e6ad32387cc7633da760c8d91649f217dea20c0d92ceae8a5f48073b89dabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1898583f4112fd9ad3dc106d970526acfbd20d2f5770ce055fb52f59e37b643"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build

  depends_on "armadillo"
  depends_on "boost"
  depends_on "cereal"
  depends_on "ensmallen"
  depends_on "graphviz"

  resource "stb_image" do
    url "https://raw.githubusercontent.com/nothings/stb/e140649c/stb_image.h"
    sha256 "8e5b0d717dfc8a834c97ef202d20e78d083d009586e1731c985817d0155d568c"
    version "2.26"
  end

  resource "stb_image_write" do
    url "https://raw.githubusercontent.com/nothings/stb/314d0a6f/stb_image_write.h"
    sha256 "51998500e9519a85be1aa3291c6ad57deb454da98a1693ab5230f91784577479"
    version "1.15"
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
      -DARMADILLO_LIBRARY=#{Formula["armadillo"].opt_lib}/#{shared_library("libarmadillo")}
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
    system "#{bin}/mlpack_knn",
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
    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-L#{lib}", "-o", "test"
    system "./test", "--verbose"
  end
end
