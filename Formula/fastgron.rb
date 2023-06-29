class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://github.com/adamritter/fastgron/archive/v0.5.1.tar.gz"
  sha256 "713ea2fcae672f63bb8f9d6708241dea43e44279e9fe593581a2978a1d8bf862"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9edd89753030db9b454d61c567de27f8c88ef99abf8f29100143d5b481b7b2ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72b08071be32b71b39ddc7a8163cdaac9d6e74a2fd5dec9255deebde882248d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c94264785987c6b838fdc30cef8683e0036e5eca37035ca870ec04fcce2e6bab"
    sha256 cellar: :any_skip_relocation, ventura:        "0fad7152b67f20634ffb024f301b18e0194a9dc9b06cf2c4198bf513be174b7d"
    sha256 cellar: :any_skip_relocation, monterey:       "0f6d6f7bc7ac930173b6144ddde84a5a1115896624ba63583a306bcd939e8c47"
    sha256 cellar: :any_skip_relocation, big_sur:        "801ae53c5803713731a5c7830ca91bbca6c3a3e4ee583c67c1ebead4c1278f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03b35eef83326e847418f827b3487f30e76346ae0f84ca9ab8e3ac34332bb34f"
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
