class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/refs/tags/0.8.23.tar.gz"
  sha256 "89fca8cdc0894a5d8392432f5012b9b3634ed2b71d07c9b4ca4ca4b6a63c1f1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4eb5b6ce734d8d797030c2d39a6b4ff90a37abe1281c4d01b4a7d1b215b3e94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4eb5b6ce734d8d797030c2d39a6b4ff90a37abe1281c4d01b4a7d1b215b3e94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4eb5b6ce734d8d797030c2d39a6b4ff90a37abe1281c4d01b4a7d1b215b3e94"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b6d1ed52257ac5b4c58bef141b91897edee6f92996f51853a5f3e67270f4580"
    sha256 cellar: :any_skip_relocation, ventura:       "1b6d1ed52257ac5b4c58bef141b91897edee6f92996f51853a5f3e67270f4580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "778c51ff129eb2143f8e8bec83ada4b8c2e339a2b8233d6dc28aa5234693383d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
