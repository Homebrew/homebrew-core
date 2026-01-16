class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "413b4ad10cabf2923ef009aefca2a3b2e4440e03dc2f8d7e9edfcd1a4852ee63"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e60848915cfcbcbb8af8f1e310b8f917a698c30d896e06aa162595400356cea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "982f6c20e7828d73bcecb383114ca8185ffac508e5f437bd774133e7b89aab90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd65025c23f3ccc7cbb77d143f07ea5d4e57129b7e41581264ff1cb59bf17555"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3be7576566a70a7b2012796e0b13ea5cf8c85479ae436f5dc26fa7bb1ca53f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3771728b89f63b2c491aa01b342f1fb29e951250907474c28904472f766833fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acb9aa2168fb41a142e3fe369410fdcb9d9fb88c3100391136a64bf49c586590"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end
