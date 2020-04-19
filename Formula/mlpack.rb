class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-3.3.0.tar.gz"
  sha256 "63cdc3569f2e929899cc30c2e808a42709723c2ea56f8c2953edc7188eab5559"

  bottle do
    cellar :any
    sha256 "6d06faa9c44c1daff2404c0f289749ef47ca93d7c5cf15f13643da5bd218356b" => :catalina
    sha256 "cda7feba2e6be17005f0c14a95480d4e0919835e704879c8b0bd992b33a29682" => :mojave
    sha256 "09749ff5392d0175de3dfdd96737397d4b5c89828054cd5a95c2defa2212dab7" => :high_sierra
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
    cd testpath do
      system "#{bin}/mlpack_knn",
        "-r", "#{pkgshare}/tests/data/GroupLensSmall.csv",
        "-n", "neighbors.csv",
        "-d", "distances.csv",
        "-k", "5", "-v"
    end

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
