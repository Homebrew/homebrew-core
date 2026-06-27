class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.12.1.tar.gz"
  sha256 "e1db6e9c3771ba137a6e9292c31870471362977760d0ca00adef2fd39e23840b"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c5a8d1a23658fbf6f900a7f9dce01b835e2afad15cd208874fdb1e5885a24cbb"
    sha256 cellar: :any, arm64_sequoia: "3a0d0c538088ec01e1dca9f4d1cc3cdda2926fcf6cf255c3ecb01f1171ef2161"
    sha256 cellar: :any, arm64_sonoma:  "51f165c86f4735b7f245185038ff65ad8a3f8ce7abf8a7d9e31fe7aa78f55b83"
    sha256 cellar: :any, sonoma:        "55e205962c2f2d9fddb743971a604f01699246434777e39d22f8f4f3151e7471"
    sha256 cellar: :any, arm64_linux:   "329251bc5b8be6b0d9f52a740a54e9cbd6ef3edb0c81c73a2fdad5b3da521db2"
    sha256 cellar: :any, x86_64_linux:  "a7e8c5dd24b445d700aa1b4673109a0bbeb63ac3657cb91facd72b4a11d9775d"
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
