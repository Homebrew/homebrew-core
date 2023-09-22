class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-5.18/lxd-5.18.tar.gz"
  sha256 "e05e2afa39f2a44e08dbfe43eb9513dcd4697497abb524678bc26f1e4a531552"
  license "Apache-2.0"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f7ef6cdc351d394f301026de28714e536048ab768bcfcfbaa0440f289553d5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76d9a9ec06e8abce1704465af0bb543ed0fc958545280cf7fece121632ee3bbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "159fd7530ff285211db64338bdc53a50ced3b22a7ddc580f42aa32d0dab77372"
    sha256 cellar: :any_skip_relocation, ventura:        "3dcb07da04278afc607ffdd2aa22ec947e214cba4911f77e1888485a44df3030"
    sha256 cellar: :any_skip_relocation, monterey:       "f235c25ed6d59bd527e5e6f555ff15a5693524062b779a68a6e664774d4ea6ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "87f6b3950ccbd890a8087340469f3617999fb278e1b6c9c80fee16f6c56ba86b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f0bbdf45d4833217bfc75bc8af5addce2bc644fef169eb6908cdfa8ef5a936d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
