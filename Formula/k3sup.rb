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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe19fba4ad87db2cb2392f6ef35f67411474be186873d28b45b0dad2a5b9d187"
    sha256 cellar: :any_skip_relocation, big_sur:       "0cb4adfc80d187190a1608247c35bee1b60916b3529e9189abb0cbb7b86dffa9"
    sha256 cellar: :any_skip_relocation, catalina:      "efb5763f36f789c9df24a68cc7716359bb76f01ca7d470ed2a43c0d532ef9d0f"
    sha256 cellar: :any_skip_relocation, mojave:        "10c68c168c1af5e94c153329a82d2685cf4a2ac4677a2ab62c1433e5e6101438"
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
