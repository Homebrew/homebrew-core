class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/v2.11.5.tar.gz"
  sha256 "dab48b785f4d2df6c2f5619a4b9a2ac6e8b708f667a4d89c7d08df67ad7c5ca7"
  license "MIT"
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bef38a72f00cf2c1541f2a6bf34849a0c8048c7ca553ac981543befea759307f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c37a3dbde37ec6ff5ba00bb00504557e1f8c908a5241ddd712c6045c9cad5ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3de7286627df04cbde8e03ca4b106c52bb4c1edc13f1fd9256399f4ac277b626"
    sha256 cellar: :any_skip_relocation, ventura:        "53ead07134ab659928fd04f1433877950f2968c7cc8db46ea3b02e30f4c2d32c"
    sha256 cellar: :any_skip_relocation, monterey:       "4c00df99bf712607fe4db01f67ccf75b5b8b2b677e62675f6e776c860c952ed4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9388d9690ef99ab96ee5ef00170a1de9657992457b591debc80c6df8b8a42f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c5a2ba36a5267f2e249f8645998d0707e6f20ca5134c1f88a16370d2900d9c2"
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
