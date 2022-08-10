class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.12.0",
      revision: "c59d67b63ec76d5d5e399808cf4b11a1e02ddbc8"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8a96d185163bbf33ba3dbf8908bc6a58f3016fc4210afa00d974de0bf1636af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18a98af7585ae5d994a5c4b42fd95401970b33333e62aa6dcf935f8f47483001"
    sha256 cellar: :any_skip_relocation, monterey:       "1e2895f78c6264f5fe15fc8c31b99bc1c2502a67797381527a7773b26a9c41dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f30c7026affa95d357e46db5ba78056e75731bf1abd70854d9beb2c6a41ced04"
    sha256 cellar: :any_skip_relocation, catalina:       "acb828deab1f44d7e90c6be4657397df4f80f60e082e9ec2f5969f25bcf910d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c5f2f1321937a2d8c5cdb5382ea2dbaef81e62b6828bc718df11c613b054e8d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k3sup", "completion")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
