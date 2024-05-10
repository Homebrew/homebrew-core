class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-5.21.1/lxd-5.21.1.tar.gz"
  sha256 "f148aa7e1fc31f6cef3038e141e9bd03787274ffc506b97376d758abf1a93cb7"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe9f866f96612241cd685a097f929e22d4f67133b3882e1f553b17f6c35cdbe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e66720eb57b8f9f50cb9780ce7b58518d32bf9a9d791fa5a1f5be081f9f3ad0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88367935917dcf0beed656957bee8ba48cae5486ed0efc6d7dc5739477aef629"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f16cdc3ad730bc74d6022fc110475a2ce684e04d294816c686f5ed9737543db"
    sha256 cellar: :any_skip_relocation, ventura:        "34ce7c3a63670667fa3ab40ba3401494d7a19d6ee10dd65b2395446e7cd5cef1"
    sha256 cellar: :any_skip_relocation, monterey:       "68a5d51e4af44ab057afda400d8b56db7216e181a4bf5563528c8e67a0b34e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8ffc34344c07eb35e85b515de822f63bb05940dd225c52e79ef444cb1fa927f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
