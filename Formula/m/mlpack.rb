class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.4.0.tar.gz"
  sha256 "61c604026d05af26c244b0e47024698bbf150dfcc9d77b64057941d7d64d6cf6"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c493daecb84e9fafae3013a3f5f1f19517ffb585b7dd5757fb84997a707588f3"
    sha256 cellar: :any,                 arm64_ventura:  "16717ad32de7e095a1820f850b6885bca2846e802f261f82f4c154a5685a9f4d"
    sha256 cellar: :any,                 arm64_monterey: "55495cabfed20643cd9fd4332843a39ead25151aefa790d2fd05a6eacbe18ea4"
    sha256 cellar: :any,                 sonoma:         "3179971fdaf5d6618c137499b15ff1bef945b0d25a3db3a1c5a205ffe364e7a9"
    sha256 cellar: :any,                 ventura:        "5817d2ece8f42980c391130ba019d18eebba81fffff7dd2e22fcfeede51c69e4"
    sha256 cellar: :any,                 monterey:       "d830509c7770fca443e99a2d97bed4de930002b3b533d65032eb3992f12b5754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "857f7fdad50388d56551c5189320a8c5dd56deb657313a9ac53c1bdfd2245b38"
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
    url "https://raw.githubusercontent.com/nothings/stb/0bc88af4de5fb022db643c2d8e549a0927749354/stb_image.h"
    version "2.29"
    sha256 "c54b15a689e6a1f32c75e2ec23afa442e3e0e37e894b73c1974d08679b20dd5c"
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
      -DARMADILLO_LIBRARY=#{Formula["armadillo"].opt_lib/shared_library("libarmadillo")}
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-L#{lib}", "-o", "test"
    system "./test", "--verbose"
  end
end
