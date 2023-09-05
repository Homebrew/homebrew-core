class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-5.17/lxd-5.17.tar.gz"
  sha256 "db5a70f10f14623bb175a2b3357a136a7c71c933515d76ee7ab2193c840ae328"
  license "Apache-2.0"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73117dfe7a0e1fa7fb7d2df4a333171397c33e06ec049268363c63026af35464"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f9eac41c3492852bcc9f8489897bc9f348863f4cff0cea4e7a36cb9429698ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ab885370572f1ce8b64f1014afcabc193205510499e81879285d000f84fdd1d"
    sha256 cellar: :any_skip_relocation, ventura:        "1930707c20e2bf6db5466dcea6dc4a1845b7f7fb60a8a1f7862a2ebe794cd984"
    sha256 cellar: :any_skip_relocation, monterey:       "e111ce4e23ff532411e016b474d8ef0c725aca2a4d5ba7a1faf6daf363ada978"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cf5f8f72dab4ac8dc3bf450dc1c16ca4763c89c5f99734e30218fea7d08e1d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72907473ff65f6352509727eb7a60c501286b4bffc984791927e5e1c59e77a9d"
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
