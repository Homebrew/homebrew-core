class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://github.com/adamritter/fastgron/archive/v0.6.4.tar.gz"
  sha256 "9283c211002764987813d5a6ea3844087517f6d313fd7ec1916478801ba200ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fc68bf281e4840893fdd0e39ac3dbde60ff7a5ddfd4fc44b544657d3e818d8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feefc96f2e0b57191dfffecbb830f52bf17882aa41268233eb279fa9f6c8c693"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bc17c1f469fbafc8e8e963740295c92e81e499cd86da57abf104753a457c7fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09473d2c8bb9905c5bdfee8cf092f48bb88d97d18dff226290e97cf5ac008261"
    sha256 cellar: :any_skip_relocation, sonoma:         "180012557050af1b371bfc2bdcfe7d4f84ed7157b9f0f3dfda064cd8e2a7244a"
    sha256 cellar: :any_skip_relocation, ventura:        "ff26548cd8a076e58ee24d7bd8e0db96f19638a7d5ad8bc0ab55ecddc25b6f5a"
    sha256 cellar: :any_skip_relocation, monterey:       "59fad96a88d6b3d8bae5c7257be4b1200e1eb93274545c3590f061c4c2345271"
    sha256 cellar: :any_skip_relocation, big_sur:        "74f38842281d9f2f9d84e073e1f10e25b89b2adb1c781c081ea09f6d9fb43a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f96d9d3a384e8a9d14c6d86455ea90bee93fc6774d66b24287407f5125e76fa5"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      json = []
      json[0] = 3
      json[1] = 4
      json[2] = 5
    EOS
    assert_equal expected, pipe_output(bin/"fastgron", "[3,4,5]")

    assert_match version.to_s, shell_output(bin/"fastgron --version 2>&1")
  end
end
