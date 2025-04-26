class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "071f289dc961b43a3b7c8cbe8a305290a7c5d308ec4b2f586397749abdc88296"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "897eb5eb032e542e77238210a905478fb2e1de29495468e82ad7ebd59eb231fe"
    sha256 cellar: :any,                 arm64_sonoma:  "378c5d953705ce41530e38773daa6cba1ff2d002adba27f9dd73c14a9aba6263"
    sha256 cellar: :any,                 arm64_ventura: "7f9363bd89ea070cd29b4b3ab7ebed3930cc40a62b744875edbc78d01607a3d6"
    sha256 cellar: :any,                 sonoma:        "0e8bf0bd266267c53d160d507c956519b5a0da368d97d98074e27c4c1bd7fbba"
    sha256 cellar: :any,                 ventura:       "85bb546408984a91677aeb31de34b932a318f95932d745f4bca2fa9c16e0544a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48d6a3c5e111e292dab316cf54ea767ee150825453e249e50a8b0be72b2edd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2035a5fe53e43eecde496ae023f3210d05d2d4d1d1200b7e4160c866f9b43cde"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <oneapi/dnnl/dnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system "./test"
  end
end
