class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.10.3.tar.gz"
  sha256 "a5252317113cf90e687a532b2e961126206b29829c61d6507fc69881e85d1d34"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "90806f04f7b95fbd43021e7efa9c9e02acef136fa03c731930db4c1a307a5f84" => :big_sur
    sha256 "8cae955f23da39b7322ca960edd82ec3ff4f894e1331ed4661ae6e178b778d6d" => :arm64_big_sur
    sha256 "8c608e9147c4f83c6ba931d16967d688e71afb82aaa1a1ba9807e7a23fde0437" => :catalina
    sha256 "5da3e7ca14e3f6305f4b104490656e6d0edc94ec6e73d8d3eb5a6cf237819680" => :mojave
    sha256 "2187f28963dc9493cf35d9014eead0919e27ef77072f705787b6bd7d446ce03f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
