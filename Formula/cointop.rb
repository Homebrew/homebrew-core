class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.6.2.tar.gz"
  sha256 "1dad6400ea342db7a5915065788a4177221269a12ba1669bed50cdee9c97dd64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "119de3a7181a66a9936ee9256b1fbddde1da0dcf771d1867265d55ef207b260d"
    sha256 cellar: :any_skip_relocation, big_sur:       "455dc455f78cc86a55e57142406b79ce177f8a5b39ccfaa45e4f44202ea5d465"
    sha256 cellar: :any_skip_relocation, catalina:      "d0ec2571a3c17b519a9fc04ea28ccc28b7d0a3f0f6e849a4d87e0dca61027c6b"
    sha256 cellar: :any_skip_relocation, mojave:        "c339718b684aeef43cccd666938f0278a68726c64251e1602768447715f738d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
