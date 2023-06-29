class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://github.com/adamritter/fastgron/archive/v0.5.1.tar.gz"
  sha256 "713ea2fcae672f63bb8f9d6708241dea43e44279e9fe593581a2978a1d8bf862"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dbeb22bc8040fa493808296f63df10814d2254b08d778fa05e42de67aa7de62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac0ff8bcdc6d7a639032bbc9550aaf41c10ca5aa789790ef053e01009d7407e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "761ae7dcd4c2accbe531130e81ce0107312ba67d6dfa7cdd112e3624b5449e25"
    sha256 cellar: :any_skip_relocation, ventura:        "a3b6ad749a6ae4eb9a8a19708332285ee7d5994ad0f19bf1b16ec5d5c109f382"
    sha256 cellar: :any_skip_relocation, monterey:       "067c945c716cc5fbb716cd670490492fd9392289619ab918ee2263784b413a2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "60b7dce4f0a31b0f225929a21e9e998222ea481a6baeeafe182d800421266bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c2992581aa247cd37011859d91e98f80fb8cab0d876b907c05b96bd1ccbcd41"
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
