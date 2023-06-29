class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.23",
      revision: "3a36fb5e13bcb6455e000d3e06bcfd998e9895ef"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4fdd280f00a74c14dcaa6c3a7643880bbea9c408f265646570edc2352244962"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4fdd280f00a74c14dcaa6c3a7643880bbea9c408f265646570edc2352244962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4fdd280f00a74c14dcaa6c3a7643880bbea9c408f265646570edc2352244962"
    sha256 cellar: :any_skip_relocation, ventura:        "7ecdbfe08fe137e19663d99a4dafde622149928c885b538b2e6876d1340a3c9c"
    sha256 cellar: :any_skip_relocation, monterey:       "7ecdbfe08fe137e19663d99a4dafde622149928c885b538b2e6876d1340a3c9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ecdbfe08fe137e19663d99a4dafde622149928c885b538b2e6876d1340a3c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb7f3f5aa509f5ac85c4914d05759d5c0ce96f57d98bbdd65d9b3e9a94f24f43"
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
