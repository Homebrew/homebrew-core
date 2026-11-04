class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.14.2.tar.gz"
  sha256 "ed509c84b9d73bacabff00e6aaedbde570568e26dedb129030fee9c8c196f168"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6f62cd1d15b04302e5bbb64354767b35260ad3312f1db47ee26fc999154a465d"
    sha256 cellar: :any, arm64_tahoe:       "7a01f0f127e6c7fa1984d8a4638a087fc24ec7d9d8aa1a867404d5e472ce416e"
    sha256 cellar: :any, arm64_sequoia:     "a060e6a5e61114830fed6d8a8e66e63e9d9ed4792ddecb4366b26d1fe926233f"
    sha256 cellar: :any, arm64_linux:       "fb204f365237fc62e07788f5f1297c8903067cacdb6d699d856954e1a999bca8"
    sha256 cellar: :any, x86_64_linux:      "00abe0dc32e28cfb98ec5a6959105ad09e9ae2dfd3e15bfe89692280afa9a39c"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    # Keep KleidiAI's per-target `-march=...+fp16/+sve/+sme` flags; kernels are selected at runtime
    ENV.runtime_cpu_detection if Hardware::CPU.arm?

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
