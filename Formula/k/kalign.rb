class Kalign < Formula
  desc "Fast multiple sequence alignment program for biological sequences"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "983bfd7da76010d59c3de3bae3d977cac78642c5eb061009dd12b11b9db5190d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "11bcedd722af4c6c3703fbac5785f7e8c6b6fbe24d618fc4d56f54c088a8a0c0"
    sha256 cellar: :any, arm64_sequoia: "fbbac6301fca1689cbcb009a337d5f3f592f344e99d88c554e000322b4406fe6"
    sha256 cellar: :any, arm64_sonoma:  "bdda94dc4686d7f8321b0ecea9546b46af48e70ec16a0e90425dade6b42d37dd"
    sha256 cellar: :any, sonoma:        "31ded0e6f6a5be3ff4722b577735dbf1680b02207034bad00450540bc47c209f"
    sha256 cellar: :any, arm64_linux:   "2ff9b4489430c6f92b8f7c2bda793cea799e70a086d149316ed3c3f17dc4f617"
    sha256 cellar: :any, x86_64_linux:  "f13dc7d95b1f7e5696259cea071a1a3e79233ab2f75d6d1ddc4fc46309ecf3f2"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

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
