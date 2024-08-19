class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://github.com/adamritter/fastgron/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "3011a3b99cd07d42648b2e964f459024b13ecc904d30501f0493fb0dc9fc33b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7374e488e419e340057a89ca0c75c8ab18f26fec54e729b75d8d27f0390f79b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f925e09414fba335897ba67999bd674c8e2c8748aa13fbb1f6f2960467e3613a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e90031e801cfed2013a80c38f32b7c4788e7282aa0163723e4141e33f5299b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ff4b53ee3e5687edd4a35f270a3b13b4d822cdb50cab09ef22b51f608493659"
    sha256 cellar: :any_skip_relocation, ventura:        "3f5469196d51e258b7baf7cb7ee982d4ecf9506eedd9fa8cf475d5c89d9947bb"
    sha256 cellar: :any_skip_relocation, monterey:       "54a91239a017ae40c51bbbe08d1d6b444858cfbd4e54d555f1490f9d33c5e179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "149b9bd41abdc81948522c8b37dc2580eaa2242a1045798eb22ac6da45201b08"
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
