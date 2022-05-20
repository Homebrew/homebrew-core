class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.11.3",
      revision: "e2bb18116d3686bf53cf40fe0998af7b6c9cf8a6"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3d66c72cdaadc1dc97b2d28763d1943b16f5d96124e19e703b9618d22a23d7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5284958a0f20f78aa4fc879482d167276119ed3ade631839d31ea568fa65d774"
    sha256 cellar: :any_skip_relocation, monterey:       "5da6c2673b94b2331820707e4d7fa075d4db08dcd5b57afb586e788ed31a6888"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb8bd85925544da7369dd123383d22c60046e1a0861c56b584cdd9ab6e691ded"
    sha256 cellar: :any_skip_relocation, catalina:       "fa6e400fc912c6bf18c95ca45d24b7307ba81895e8424c92ef27f9c29f6a4439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e7d21a5c3b460560123484eb0d9fb10150f64b75410a7d455ff64282de3fd1f"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
