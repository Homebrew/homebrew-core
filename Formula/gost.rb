class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/v2.11.5.tar.gz"
  sha256 "dab48b785f4d2df6c2f5619a4b9a2ac6e8b708f667a4d89c7d08df67ad7c5ca7"
  license "MIT"
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a038791ff4264c47f939d8c23da79d7c2c6973908078a266a1c6e6b6b62bf554"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15980cd4a66cefb943da580fda1debf22ae133a7dfff87544ee6e99b44a0c45a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18fe7a2a916b7989b4c8d1ca8136001bb8eff011ceee2f6bd68721ab402fbab0"
    sha256 cellar: :any_skip_relocation, ventura:        "bb5575025c71775c7f6ab8110ec58a314271a75522b0fc419e0d339466b02619"
    sha256 cellar: :any_skip_relocation, monterey:       "7247575e8ddd0fb98d8894f33a0534e2254cadfeafd1216a8c211ebb61141e4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbf1914a54b4ca00a52ce37a1519856a49eaa35a50f8afd7d0ede9ac5de352f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b99cc2fdc814773ed05924490b3896473889ad7a933b7ce1c80e53127fae5c"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/ginuerzh/gost/commit/0f7376bd10c913c7e6b1e7e02dd5fd7769975d78
  # Remove on next release.
  depends_on "go@1.19" => :build

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
