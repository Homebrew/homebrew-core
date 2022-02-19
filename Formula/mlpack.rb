class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-3.4.2.tar.gz"
  sha256 "9e5c4af5c276c86a0dcc553289f6fe7b1b340d61c1e59844b53da0debedbb171"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  revision 4

  livecheck do
    url "https://mlpack.org/files/"
    regex(/href=.*?mlpack[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ed0099d51ab2ea2ea0cd6dea36dbb9e910d8392759b64d01138fec8d6b108a52"
    sha256 cellar: :any,                 arm64_big_sur:  "796491ddc6952c780fbbcb645c2e50676583d686f8629767c2c18c604502639a"
    sha256 cellar: :any,                 monterey:       "33f53bba8a507d8fac2083ecc06c3e954dfca03329da40051f8b343afa46fc6d"
    sha256 cellar: :any,                 big_sur:        "d34ef6b922a4c823b27a50dff5e5c493a5a10d53a9df8d18280120dc7e26156c"
    sha256 cellar: :any,                 catalina:       "1ee7f05bffff56eb1e587cc8077e2c582ab657ddfffbc0aa3b919e888a526ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c61cc6e856603b9f43b28e2683b09953422e3fa6998ebdc8a7fe0cd9ac1409"
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
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
