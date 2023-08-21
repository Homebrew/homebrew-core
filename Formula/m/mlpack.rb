class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.2.0.tar.gz"
  sha256 "f780df984a71029e62eeecdd145fb95deb71b133cefc7840de0ec706d116dd60"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b7bb9296ce668c681abc7b124a3f7e43db04ac518fc734174a6182d3000a02e"
    sha256 cellar: :any,                 arm64_monterey: "61f246b70bc7a71ce08f401a4c45ea0c0fb367ad24434886dd366f2d5164b792"
    sha256 cellar: :any,                 arm64_big_sur:  "815a02a35f0a843d1c74e1146dcff088bcc6843460d738312a42dc8770c6c045"
    sha256 cellar: :any,                 ventura:        "afa0360aaef101846a80b27118abbbf82828859b2c71cece4ee33c0ef6059c15"
    sha256 cellar: :any,                 monterey:       "750e0468a64dbf22163db8a346215e07cd4e7fc26e6fe7ed08413d3110d2e56d"
    sha256 cellar: :any,                 big_sur:        "6879303fb18f5f69f5c6ed3c4c524b6a31998b3ac4521ad96cbf9179d7a49af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71fa55c6229435c86fb2fcdc73c4e84f4ddd2c5c4d8e052a84421ebee0e3425b"
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
