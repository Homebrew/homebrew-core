class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.47",
      revision: "cff5cd05cf86fba34969a80942c4d7b015ecb5e6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d36996a5be5f09538f6f3508b73e83b713f7dae8d52cc8394a692142fb2f0b4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc52d6179806072ca14174e2a755483d7582ed891039c06e88be23fdc349bc20"
    sha256 cellar: :any_skip_relocation, monterey:       "6bd27de5a4d27c6197b9daaa8b756045d7d3ff0d5cd0972c6ba73d0e1e8b867d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ba53a52ae30298df1451774e88cf9a2a9b788a1fd4621f2222c6f9262e0dc00"
    sha256 cellar: :any_skip_relocation, catalina:       "63347e0205ffa7f9f30bcde7648769f7bd4cb3a30d1fefc8b1a935b55195634e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4577f9e75713c4ac949663d9215c1d7aade5cf09f64e1ff2b5695545246dc1f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/cmd.Version=#{version}
      -X github.com/alexellis/arkade/cmd.GitCommit=#{Utils.git_head}
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
