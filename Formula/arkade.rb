class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.4",
      revision: "eef3feffaf145b4bd6e2b3fec8ba6c707aed1476"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "222024aeb0f7b77354b4b6d529dab786bf4effdb366a49bbaf226de38ce2a76f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "222024aeb0f7b77354b4b6d529dab786bf4effdb366a49bbaf226de38ce2a76f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "222024aeb0f7b77354b4b6d529dab786bf4effdb366a49bbaf226de38ce2a76f"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ffa1e2da0f2ad4288d8ece7eabaab7295f24644d7499b1aa334e27ce13a6b6"
    sha256 cellar: :any_skip_relocation, monterey:       "e0ffa1e2da0f2ad4288d8ece7eabaab7295f24644d7499b1aa334e27ce13a6b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0ffa1e2da0f2ad4288d8ece7eabaab7295f24644d7499b1aa334e27ce13a6b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c1c068beed38da6202d3a53a87f3d30ec9cf81dd52d8ffdbc86e971a000cbb4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
