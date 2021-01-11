class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-3.4.2.tar.gz"
  sha256 "ac6a8cad096829521dbb78acf75aaf457578f676dd94b700b10871a69f027dcc"
  revision 3

  bottle do
    cellar :any
    sha256 "2823af4a2e9e934bf43e68e5f6f7aef27d651aeb261d6f1b8e9585011c67c3b1" => :big_sur
    sha256 "4f4989363537f5202d017eb55a2747dc8e9cc2af5b84064c07d864abd516708c" => :catalina
    sha256 "e4a27e2f9a573d7ff942a0cfa9bc24f6f95b63ac17618e8c26258416bfc3af01" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "armadillo"
  depends_on "boost"
  depends_on "ensmallen"
  depends_on "graphviz"

  resource "stb_image" do
    url "https://mlpack.org/files/stb-2.22/stb_image.h"
    sha256 "0e28238d865510073b5740ae8eba8cd8032cc5b25f94e0f7505fac8036864909"
  end

  resource "stb_image_write" do
    url "https://mlpack.org/files/stb-1.13/stb_image_write.h"
    sha256 "0e8b3d80bc6eb8fdb64abc4db9fec608b489bc73418eaf14beda102a0699a4c9"
  end

  def install
    resources.each do |r|
      r.stage do
        (include/"stb").install "#{r.name}.h"
      end
    end
    cmake_args = std_cmake_args + %W[
      -DDEBUG=OFF
      -DPROFILE=OFF
      -DBUILD_TESTS=OFF
      -DDISABLE_DOWNLOADS=ON
      -DUSE_OPENMP=OFF
      -DARMADILLO_INCLUDE_DIR=#{Formula["armadillo"].opt_include}
      -DENSMALLEN_INCLUDE_DIR=#{Formula["ensmallen"].opt_include}
      -DARMADILLO_LIBRARY=#{Formula["armadillo"].opt_lib}/libarmadillo.dylib
      -DSTB_IMAGE_INCLUDE_DIR=#{include/"stb"}
    ]
    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
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
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-I#{Formula["armadillo"].opt_lib}/libarmadillo",
                    "-L#{lib}", "-lmlpack", "-o", "test"
    system "./test", "--verbose"
  end
end
