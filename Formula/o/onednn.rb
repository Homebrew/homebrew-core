class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.12.tar.gz"
  sha256 "efa94db6e8395daaef8e307a48e9527bbaab58a64b44e5d59a3662b4b155099d"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39a5c27c065cd85f2283a9b934f2e12419bad36518419a771f83b83375ae4859"
    sha256 cellar: :any,                 arm64_sequoia: "07255746682fff4e4cd60f5564e42b1a90298509fa304d310d287689587b9432"
    sha256 cellar: :any,                 arm64_sonoma:  "e877f201103c8a66fa68765ec88ab3884ee99f2f983dc8e96b763c70c8e0932d"
    sha256 cellar: :any,                 sonoma:        "17c91f2b18b576692bc1c7eb1a5a6a89a41222dbc479537aa753b54460cef294"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331d2698f264bac5974f4ef18bb7c5097c86a99555ec5da844c4b81ab63c1f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df694da81fb42f5e65d5c2f4a64985efba9010c42bd47cc0c9c2bf679c37cc73"
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
