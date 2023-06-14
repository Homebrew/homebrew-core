class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.22",
      revision: "ab3f8aa2a12aa2f3407e8150b5bdea97fd582a6e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bb687c7e2064a2bbd09d651a424c5b963039623452e4c703f8cc97691021785"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bb687c7e2064a2bbd09d651a424c5b963039623452e4c703f8cc97691021785"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bb687c7e2064a2bbd09d651a424c5b963039623452e4c703f8cc97691021785"
    sha256 cellar: :any_skip_relocation, ventura:        "7f0ab1501855820da5fe48b9da5056a7aab9657cb7ce40bb5100f6ff8514f229"
    sha256 cellar: :any_skip_relocation, monterey:       "7f0ab1501855820da5fe48b9da5056a7aab9657cb7ce40bb5100f6ff8514f229"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f0ab1501855820da5fe48b9da5056a7aab9657cb7ce40bb5100f6ff8514f229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df722681a83dbe2d6c30a34a314518288da482763167314b0f3a653cd5afb5d"
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
