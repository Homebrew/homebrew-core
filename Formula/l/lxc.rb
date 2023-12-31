class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-5.20/lxd-5.20.tar.gz"
  sha256 "2f958b757f4cde64d0f3578da0bda9ee5965a3a70ec0956eddf8287d1290167f"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e10ab2346013418452a0eb4a50c6661a01c04b5cc0aa97777edf684905403b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d970c509b68e783b01e5868dd585525ba71b636babb65de235475ddd0415da2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b26e1abd26ab8b7ba072656275c78592e6dabc9b1bb170f1999391e89b6aa6f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae57e6c31a239517fe0128f52aa490cad45046b5d626d7b231ef363dae21325c"
    sha256 cellar: :any_skip_relocation, ventura:        "e6d52d83bb02d954f3eb43a45ed4c6508239e3f2e580046f0ca5f4ca13aa267c"
    sha256 cellar: :any_skip_relocation, monterey:       "31f51b62feb447187a4376e60025577de645cf6dea0dacdaf2da4a84196a3b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "913f81933e9335307564cd33d66b7aa4968654f6626c1b2df2be30e1c2dec191"
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
