class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/v2.11.4.tar.gz"
  sha256 "aa3211282fce695584795fac20da77a2ac68d3e08602118afb0747bd64c1eac4"
  license "MIT"
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8073e645fde2616cbbfd0683e54138d4ec2873d4e9bdb7cb3c6c5db88653ea69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "680ffc34810e6bed784a107e3ba0ed086b3b36ac90b8b6f7b8552443d8714843"
    sha256 cellar: :any_skip_relocation, monterey:       "20612e5f65817db4d93a8f48e11878d4635954fc1c48bec5d2ce2a1e61979aec"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b961b9add49fb17f7a5217a2e7854201f7c1b20e47dd97b77c0e84742169079"
    sha256 cellar: :any_skip_relocation, catalina:       "f292653429cd8023e8eb93e2c3b088351587f53a8b01d86f7009628b6c3ed6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe525661ef844eff98698b6a354b101340ff857039dc7c4b4878b29c86d44b5e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec "#{bin}/gost -L #{bind_address}"
    end
    sleep 2
    output = shell_output("curl -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match %r{Proxy-Agent: gost/#{version}}i, output
    assert_match(/Server: GitHub.com/i, output)
  end
end
