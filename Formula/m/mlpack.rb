class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.8.0.tar.gz"
  sha256 "0ab06e5c506c7ed5f072faa4c04477c65624e4a1ff62eee8c0d996ef850ec51c"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2e6b526883e1455de59704ca34e42e2775df5f78bd4d2e04497eb0b5cc9f420f"
    sha256 cellar: :any, arm64_sequoia: "75c24e1ad876fe3a34c4c07a86cec2988c7d3d40e41b81c57f883f345cca2840"
    sha256 cellar: :any, arm64_sonoma:  "d9cccf1f37ecd870e0441b8602339e0fad4fa45638f7e21c62a87618ca80ce2c"
    sha256 cellar: :any, sonoma:        "e7c72b5ecc5ddb54eff470da1c312508a98d78a269d1b0e7c28682157c9cb00d"
    sha256 cellar: :any, arm64_linux:   "ebae5bee89f2b4dab5fd04eb9d142922260d99967b1c64a952567b752e01056e"
    sha256 cellar: :any, x86_64_linux:  "2750a2505f386a5dd7fd4d31247b0f3b52a4b21b57d121937dba27569e240cb2"
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
      -DARMADILLO_INCLUDE_DIR=#{formula_opt_include("armadillo")}
      -DENSMALLEN_INCLUDE_DIR=#{formula_opt_include("ensmallen")}
      -DARMADILLO_LIBRARY=#{formula_opt_lib("armadillo")/shared_library("libarmadillo")}
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{formula_opt_lib("armadillo")}",
                    "-larmadillo", "-L#{lib}", "-o", "test"
    system "./test", "--verbose"
  end
end
