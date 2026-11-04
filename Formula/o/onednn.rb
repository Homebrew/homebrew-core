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
    sha256 cellar: :any, arm64_golden_gate: "b44ca7c39bbdc6847b883283351d544783e0139595e1ed53bafd7f6413f3da1c"
    sha256 cellar: :any, arm64_tahoe:       "f943131dd844ab66b628c1157fda6a5d96ff67b231a75710ede44f8467514101"
    sha256 cellar: :any, arm64_sequoia:     "7fc864746c2e041a3a497ab61fdaee66be516efb31ad93d7d10686df29fbedf1"
    sha256 cellar: :any, arm64_linux:       "70ace16e963b9531102f6b07b63bef01ebc692069c2717f6fc9d818d4583568c"
    sha256 cellar: :any, x86_64_linux:      "ad88e413b9c35574100872183009cb38e6aad691698894a03e32a593461e7a71"
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
