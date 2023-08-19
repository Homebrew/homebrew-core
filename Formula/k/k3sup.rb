class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.12.14",
      revision: "e4107dd9bbd099909483fd655b815bd77319dfb6"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3257638990c025076db360261ac749d2559730e29cf9ad94e554461fea23f54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3257638990c025076db360261ac749d2559730e29cf9ad94e554461fea23f54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3257638990c025076db360261ac749d2559730e29cf9ad94e554461fea23f54"
    sha256 cellar: :any_skip_relocation, ventura:        "fa2e60197779dc8bc8eecd3a9ef4f8332ba91fb43e36bc8d369b6baa913ab278"
    sha256 cellar: :any_skip_relocation, monterey:       "fa2e60197779dc8bc8eecd3a9ef4f8332ba91fb43e36bc8d369b6baa913ab278"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa2e60197779dc8bc8eecd3a9ef4f8332ba91fb43e36bc8d369b6baa913ab278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ae22ee0f7400f8ea8bfed3faa1d2246105795d5cfe689c4bf507b32894384da"
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
