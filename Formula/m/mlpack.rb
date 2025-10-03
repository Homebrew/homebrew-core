class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-4.6.2.tar.gz"
  sha256 "2fe772da383a935645ced07a07b51942ca178d38129df3bf685890bc3c1752cf"
  license all_of: ["BSD-3-Clause", "MPL-2.0", "BSL-1.0", "MIT"]
  revision 1
  head "https://github.com/mlpack/mlpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fafb84f8935480c1acd9292b35c7f9182630c3470b57208affd1ce91183e5c66"
    sha256 cellar: :any,                 arm64_sequoia: "0f231088b602989d6095850417438746516ef210652387a9f0f61c3e313dbcdb"
    sha256 cellar: :any,                 arm64_sonoma:  "6e454187ba47af0f60ee2b2078019609334a7150bf1e32cf275806578e0209aa"
    sha256 cellar: :any,                 arm64_ventura: "fbea7810d131e9dbc46934e12b099668d489245ff4ff0e713ad389fc6e0c7446"
    sha256 cellar: :any,                 sonoma:        "eec48db4276a78796a6575217149699695f1293eb72a59b102392eeb758539f9"
    sha256 cellar: :any,                 ventura:       "fb3c6e65de5aa0185b6804b63a7c402c076d14fff7fd80aa4ab3f0dcb97c6861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50f3a0812976d56eace19a2c43651aaf3e13c13e65d891ea136b4c2318954c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb65951d9d4b3daac979132bc1401290adf03b4c001d4bd5bf0700695db6cde"
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
