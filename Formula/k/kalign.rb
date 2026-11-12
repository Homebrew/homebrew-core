class Kalign < Formula
  desc "Fast multiple sequence alignment program for biological sequences"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "3292ac61a6d2af195e5100650b26cf87dcab75d14167ce39d5b4d5b78ebe5b77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4c43619c7d280716e5d59e91a1858ebb2e0ce2a234968aa6ee8ff147655fc88e"
    sha256 cellar: :any, arm64_tahoe:       "a7484a3ce74c4fc64389e85ef0420f0c646c58b754228f72764069e0149bddda"
    sha256 cellar: :any, arm64_sequoia:     "2eaf0722a0781be6c30838c5c5848c44fc940dfaf51b27b4cf8c82861009f958"
    sha256 cellar: :any, arm64_linux:       "8f252500d42988e39bd5ebef2954a8cf0f7a024996433100857c56ba050f117f"
    sha256 cellar: :any, x86_64_linux:      "75ca80be9c96ef176d284818c7899a7a1f5af839f08eff8175a3e90317131dd3"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  deny_network_access!

  def install
    args = %w[
      -DENABLE_AVX=OFF
      -DENABLE_AVX2=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = ">1\nA\n>2\nA"
    (testpath/"test.fa").write(input)
    output = shell_output("#{bin}/kalign test.fa")
    assert_match input, output
  end
end
