class Gotify < Formula
  desc "Command-line interface for pushing messages to gotify/server"
  homepage "https://github.com/gotify/cli"
  url "https://github.com/gotify/cli/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "d44d0058a87684db8c61a9952a84327f7bab102d6a4a16547f7be18b9a9c052c"
  license "MIT"
  head "https://github.com/gotify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7ab87d86e6fcd672cac1d2674c6be77bce527bd61b04bc48aa67f1dca35ad46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a65045f1d44b21b89e38c8e153e8502b15d44d59ce19ec4f8571c8d860f448e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14d9bf0ed0eb81919268e921507bbee01627bf672eae85bf76439dbafb52ee27"
    sha256 cellar: :any_skip_relocation, ventura:        "373a1c2f2bcbef959b6d3a8cd71d217669641cdbc0ff31206c280a8f8fe7e5a6"
    sha256 cellar: :any_skip_relocation, monterey:       "646670177e99bd1781c9987916c1a19e259a66645d531cc8186c5b1cfd20799d"
    sha256 cellar: :any_skip_relocation, big_sur:        "48711ef7f1fc3c969fd760acff1d52e1dbe12e6aa22ee037f0dce9f958634e21"
    sha256 cellar: :any_skip_relocation, catalina:       "08586691d4beaec4643df08ff654247cb76af56babcb1fbb43fe83059b01a4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1d361ab19b51bbbc0f42aafcff152d4b088f8a041da099435efcdaf01b4723b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}
                                       -X main.BuildDate=#{time.iso8601}
                                       -X main.Commit=N/A")
  end

  test do
    assert_match "token is not configured, run 'gotify init'",
      shell_output("#{bin}/gotify p test", 1)
  end
end
