class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.10.1",
      revision: "7ff6f60c0bbb78e79db29539b0973d630fb32eff"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "399eef48ae6c99670ae155702342a029bc2a968b76989b923a0a1e172c5edc6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "fbf53bb9f4254160d26af818d181b37f481022317e64a6f0d44e3111aa27a615"
    sha256 cellar: :any_skip_relocation, catalina:      "169bd90456da1d96036fed4fbe3ffcecbc41b9a3bd8531500ed420dcac730ef4"
    sha256 cellar: :any_skip_relocation, mojave:        "d1bac8283437c64e621dd89a8fc18a0ed47f9d164b251a2fdefad08a711591e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
