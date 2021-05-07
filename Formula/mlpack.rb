class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-3.4.2.tar.gz"
  sha256 "9e5c4af5c276c86a0dcc553289f6fe7b1b340d61c1e59844b53da0debedbb171"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  revision 1

  livecheck do
    url "https://mlpack.org/files/"
    regex(/href=.*?mlpack[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "4a4f0445379fd5de750ba908031066e03583ef49811f263ab4dd7a9df214c3a6"
    sha256 big_sur:       "e515f2b61881b192bce1e0d0d35a2aeacdd16a675bb312fb69cbd4cda0c654d1"
    sha256 catalina:      "a8c30f5b0543ec3a71f3c033e9b0849f8ee992b9ebef732cf3f30cdba13db9ba"
    sha256 mojave:        "7ff71383919176ac3eb2b83f9667ebbcc4e475639c8b135a660ed30456b9b811"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "armadillo"
  depends_on "boost"
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
    cmake_args = std_cmake_args + %W[
      -DDEBUG=OFF
      -DPROFILE=OFF
      -DBUILD_TESTS=OFF
      -DDISABLE_DOWNLOADS=ON
      -DUSE_OPENMP=OFF
      -DARMADILLO_INCLUDE_DIR=#{Formula["armadillo"].opt_include}
      -DENSMALLEN_INCLUDE_DIR=#{Formula["ensmallen"].opt_include}
      -DARMADILLO_LIBRARY=#{Formula["armadillo"].opt_lib}/#{shared_library("libarmadillo")}
      -DSTB_IMAGE_INCLUDE_DIR=#{include/"stb"}
      -DCMAKE_INSTALL_RPATH=#{lib}
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
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-L#{lib}", "-lmlpack", "-o", "test"
    system "./test", "--verbose"
  end
end
