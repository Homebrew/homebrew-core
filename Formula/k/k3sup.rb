class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.10",
      revision: "5d97659e0d8bac3c3c497d4ff1d5d04a0c341b8b"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "417ff661cf30f1c1d103841d7941873ab4faf5ca47e3a31c89fe5572ccd60c6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "417ff661cf30f1c1d103841d7941873ab4faf5ca47e3a31c89fe5572ccd60c6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "417ff661cf30f1c1d103841d7941873ab4faf5ca47e3a31c89fe5572ccd60c6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce23b0e0b23d7d755e4c9530c15700b37741508de4ce7415ac537289538b2479"
    sha256 cellar: :any_skip_relocation, ventura:       "ce23b0e0b23d7d755e4c9530c15700b37741508de4ce7415ac537289538b2479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79a72c2efdcb69a2a8dea4dcc39558c2099811fef9d1c480b19ef6bafa6f4eb7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k3sup", "completion")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
