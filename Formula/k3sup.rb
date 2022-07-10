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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bcf2ab6b4e2dd40cebdd503244ce170ef6de4df9ee1f20c456bcffa8b6bfc8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11e65ae436a7c3182571cf493399d6e4020fcce3dbbe9ebd71d6bfe92649ad88"
    sha256 cellar: :any_skip_relocation, monterey:       "141378744064abe439e4a2887b2a4ea4e95fa10fd88f42a90d5f7ffdfc55d32c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2240c3cee25d35c85b40e20c37ff0c9d8227d9bf67b06e2a85b1cbc771063833"
    sha256 cellar: :any_skip_relocation, catalina:       "da31589684c74a98882ad74b8ace492ae7adef7a73117840e47b87f1ff0af83a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aef241481102a754158b5682490aeb8df4cf657161e0aeec21a257ae41eb6453"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    (bash_completion/"k3sup").write Utils.safe_popen_read(bin/"k3sup", "completion", "bash")
    (zsh_completion/"_k3sup").write Utils.safe_popen_read(bin/"k3sup", "completion", "zsh")
    (fish_completion/"k3sup.fish").write Utils.safe_popen_read(bin/"k3sup", "completion", "fish")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
