class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/v2.11.4.tar.gz"
  sha256 "aa3211282fce695584795fac20da77a2ac68d3e08602118afb0747bd64c1eac4"
  license "MIT"
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14e62616254d43f72f8705e1a00e53b1a80d9acec991502c089c47fd6a6d7109"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42352933d08a976b8f00afd0ce00546bcceb860367c3709f09a562b3ca131542"
    sha256 cellar: :any_skip_relocation, monterey:       "efec94d4398a9af35440fba87074ce305b24ca9b62b57f78142a9d5321041c5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "908c9b5c168570994e93e83ce436075fad09467a0b49ca418c42f60acbbbdca9"
    sha256 cellar: :any_skip_relocation, catalina:       "185c4c7c5e432f2239347c64bd73cd7d93dca332e52765d14e1498d8c433e41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa9b695ece2ed1a5f9d95c8ea08b76dd35ce5701f200caf77fbedd6f6838e215"
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
