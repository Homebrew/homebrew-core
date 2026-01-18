class Lnk < Formula
  desc "Git-native dotfiles management that doesn't suck"
  homepage "https://github.com/yarlson/lnk"
  url "https://github.com/yarlson/lnk/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "aeb60a34139af39fe9a495cf15b261e2c743dd757599737a1db36dd1ae997b96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bdfa814f7e2cb0beca968390b851594778eac8acbd4094d3b24c89ca2fa9079"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bdfa814f7e2cb0beca968390b851594778eac8acbd4094d3b24c89ca2fa9079"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bdfa814f7e2cb0beca968390b851594778eac8acbd4094d3b24c89ca2fa9079"
    sha256 cellar: :any_skip_relocation, sonoma:        "57d415d120c7491ba3360354bdceab4017e3f4f15708f84bd7d620ca60f2f99e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4a69b32d91349e951882b718b8df5efb2645ffbabaceafe676398eb970fe8e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76b53749911e3b1c28addc7e4588afbe0b9abfbaadc05fdc57b451db5ec6b0b4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lnk --version")
    assert_match "Lnk repository not initialized", shell_output("#{bin}/lnk list 2>&1", 1)
  end
end
