class Kalign < Formula
  desc "Fast multiple sequence alignment program for biological sequences"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "983bfd7da76010d59c3de3bae3d977cac78642c5eb061009dd12b11b9db5190d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f71e40d9b45732086ee415ec130e03e09db751f393cffb319bc842992ea28b2"
    sha256 cellar: :any,                 arm64_sequoia: "2358d378a572b07517447d5211684f215a6b6f5b406c976c1b4db4cbc5a78379"
    sha256 cellar: :any,                 arm64_sonoma:  "9e6edbd6b9e00a838c9ab9183cd9a0664c2ba097d3beffc7b8d5389f77ecea58"
    sha256 cellar: :any,                 sonoma:        "10acec6e6df25811d99e0719a143a5a7c7bba1e1c223baf2e249b942c3dfb0f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86fb9adacf8e8c08495cf7c8673618272540df6c7b26cc4d584d850b066b1d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f797b66afe74876d22fb87c3e59b2d0ba9f004873d2127e631a4026178409e5f"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

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
