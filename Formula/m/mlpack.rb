class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.2.1.tar.gz"
  sha256 "2d2b8d61dc2e3179e0b6fefd5c217c57aa168c4d0b9c6868ddb94f6395a80dd5"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e8a7f13d5e89f237abc2b513132fd4583d7ade51a74d4a27332ab18d23c9648"
    sha256 cellar: :any,                 arm64_ventura:  "077600d242430882c33eadd1650c007751da07d04cb7f851de9d1882691f164e"
    sha256 cellar: :any,                 arm64_monterey: "924a161c34217e7a3d5d0dcbf150b4180e10f0a8e65aeda1c63c2f54ffbf0c73"
    sha256 cellar: :any,                 arm64_big_sur:  "3b8e764e6b4e77cd77964267b4614860c8ef917bd4cc6e92ddf3c68bae4bf5de"
    sha256 cellar: :any,                 sonoma:         "4f8a4c60dd80cf8e7e8732dca1fa05a6e553d9126dd892e561a57ddd71677483"
    sha256 cellar: :any,                 ventura:        "abf2efa2216abb77be8716c9f16733e4271ad3ad5a8b331801bcbe9ff185bbcf"
    sha256 cellar: :any,                 monterey:       "52f27dccecaf95dc59b3372e3a26d4140852e902cec5ed925f84be08338c9cbc"
    sha256 cellar: :any,                 big_sur:        "c085f0272837d4ae0da9cafce1341504ae3931c939dc9bfcbee9f42e93863e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "606fb38ed22b4b1dc7e5952709d258fe68083f2989768fe8ee0a53d132933fc5"
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
