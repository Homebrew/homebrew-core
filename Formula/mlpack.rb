class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.0.1.tar.gz"
  sha256 "4c746936ed9da9f16744240ed7b9f2815d3abb90c904071a1d1a628a9bbfb3a5"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  revision 1
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dcb754e45a2335db6665131e49b02bde377a3c057e5036888fa8bdd9c373caed"
    sha256 cellar: :any,                 arm64_monterey: "5fdb4ea81eb8729c3f496f66c6056e98eaf22744ba7d838609901a22625c3c28"
    sha256 cellar: :any,                 arm64_big_sur:  "4b63e693eb879b561d8692513f58b6e8f18183bed6b30ce6f76c8bcf3029e7c5"
    sha256 cellar: :any,                 ventura:        "0e6de9bd9142c13f38b13c85b2c00c4f4c449014a5ef78be3e52c56bc943bc2a"
    sha256 cellar: :any,                 monterey:       "a5055fdda100071ceb71884062cc2726aaa534bf1c422d2737abe1cb5bc582a7"
    sha256 cellar: :any,                 big_sur:        "986d610ceb522d05117b5ea07e920872ed4283cb3758886846ff5374222815a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfdbdbc9e6f431d4853e443204d0490b6d18ba9f2ba79aaebf0b919f743c3320"
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
