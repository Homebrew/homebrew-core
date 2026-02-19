class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.7.0.tar.gz"
  sha256 "a3f0fb530e51d51f8d7eceb7998b4699906d628000b158ada80541465595324e"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b331d69b57ed9d4d0019c88e06df3279b143bfcee03f081675d6224e611e83d"
    sha256 cellar: :any,                 arm64_sequoia: "0a562de79e6c8e22c4434b626af424ba666bc04ed83ae904a5c397a7899da4aa"
    sha256 cellar: :any,                 arm64_sonoma:  "45cac3d79a3e818acec4701d478e3e6b868f6d5590ba347f24a1fa192a76674d"
    sha256 cellar: :any,                 sonoma:        "85365a6ce18c3e3d22cf43e84867e82dfd804176c1bf83ebeb714e51e6eb3bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22de66681bdcf9d2e8345a9211add0e8baa16f0fb26afdb8f888040bc3c52887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e85b017257022ffc33619d39237a1b612453b594c0aa04179cae05c241c36fcf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "armadillo"
  depends_on "cereal"
  depends_on "ensmallen"

  resource "stb_image" do
    url "https://raw.githubusercontent.com/nothings/stb/013ac3beddff3dbffafd5177e7972067cd2b5083/stb_image.h"
    version "2.30"
    sha256 "594c2fe35d49488b4382dbfaec8f98366defca819d916ac95becf3e75f4200b3"
  end

  resource "stb_image_write" do
    url "https://raw.githubusercontent.com/nothings/stb/1ee679ca2ef753a528db5ba6801e1067b40481b8/stb_image_write.h"
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
      -DSTB_IMAGE_INCLUDE_DIR=#{include}/stb
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

    (testpath/"test.cpp").write <<~CPP
      #include <mlpack/core.hpp>

      using namespace mlpack;

      int main(int argc, char** argv) {
        Log::Debug << "Compiled with debugging symbols." << std::endl;
        Log::Info << "Some test informational output." << std::endl;
        Log::Warn << "A false alarm!" << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-L#{lib}", "-o", "test"
    system "./test", "--verbose"
  end
end
