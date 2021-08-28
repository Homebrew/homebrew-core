class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/v0.11.0.tar.gz"
  sha256 "6b3e005b6bc2519e2c7b4767fcf66a49dc3e8d34c19cd3c6c3d5517720d4f3ff"
  license "MIT"
  head "https://github.com/iawia002/annie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8cae955f23da39b7322ca960edd82ec3ff4f894e1331ed4661ae6e178b778d6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "90806f04f7b95fbd43021e7efa9c9e02acef136fa03c731930db4c1a307a5f84"
    sha256 cellar: :any_skip_relocation, catalina:      "8c608e9147c4f83c6ba931d16967d688e71afb82aaa1a1ba9807e7a23fde0437"
    sha256 cellar: :any_skip_relocation, mojave:        "5da3e7ca14e3f6305f4b104490656e6d0edc94ec6e73d8d3eb5a6cf237819680"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2187f28963dc9493cf35d9014eead0919e27ef77072f705787b6bd7d446ce03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759aff3b06afe590513ec26419cf8eade0a85ec954ca9064ae414154ab5256d6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
