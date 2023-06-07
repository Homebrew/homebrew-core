class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.1.0.tar.gz"
  sha256 "e0c760baf15fd0af5601010b7cbc536e469115e9dd45f96712caa3b651b1852a"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c4a23609ba6ef874dcbda937f71ef97c4c48d7a001f504f39be09dde28e42f5"
    sha256 cellar: :any,                 arm64_monterey: "f1eeacec19c1a01b7ba0e27c8aeba78019d0f0d0c19d450b6903becd8a408312"
    sha256 cellar: :any,                 arm64_big_sur:  "964ad616cfe1fa3d4845e5588ef5f5b5908c563e3a18bd2549ef5f95fb19ee4c"
    sha256 cellar: :any,                 ventura:        "c1591a839d37ba8fd5c53c02c92f11012d05a9743dac5f19216ac5e2f35af198"
    sha256 cellar: :any,                 monterey:       "cb66cc43d903722b0615b0303a59f57b98694db3c22fe7655126a31ec8b492ed"
    sha256 cellar: :any,                 big_sur:        "dd846f2505b8b2bb83ed5fe1d9de4f380507f55a02b0d23481d09516018c284b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15d8636c83c58455a3f0e8797fa361e10bb61c64485d27fe4a080d2fb413793d"
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
    url "https://raw.githubusercontent.com/nothings/stb/3ecc60f/stb_image.h"
    version "2.28"
    sha256 "38e08c1c5ab8869ae8d605ddaefa85ad3fea24a2964fd63a099c0c0f79c70bcc"
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
