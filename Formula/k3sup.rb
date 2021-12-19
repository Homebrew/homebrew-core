class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.11.1",
      revision: "95cf0b1332c3b2b7eed4bb2d7154bec790b8ea41"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83e8f199e73e8a561385a9346f549f7b75de76620cbaf4244807b7da178a2283"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f577d61918afc1d0a10991344c437e44198a0eb531f4b8527470204211adba7a"
    sha256 cellar: :any_skip_relocation, monterey:       "d05dba1a3b11bedce146770fb29b395e33248b8782bfeeb346c7690ec884ff9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "11451e3b6b47864744fa097787ce8995990fe49575fae5a235c9da3285f552ba"
    sha256 cellar: :any_skip_relocation, catalina:       "6cf6ae8ad7b89a26112faf00432f893b7370d8b9b556d692af7e0a5a93763128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b762e1879720428cca5c58a28950e95c30da182c00aba891ecf969af1d527e45"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
