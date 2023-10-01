class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.7",
      revision: "fec33ae658a975b59aa645f23d48e74930f43dda"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1602ceb2276ad4a72026dcd958c8485d065cefca13377bca58035e0f07f71aff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f5b2cf6943c1cb9f3c503eb9719f8db6a8d121e6df6709d8337ce2ab4b77d04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daa0895e7fe06a307cd67299b0afb88dd04ea3b3db40657873917d8119b7330d"
    sha256 cellar: :any_skip_relocation, ventura:        "228d64aa4cf552e2868e2784d2b09870665f8228060939f1e384297c84a0d9ce"
    sha256 cellar: :any_skip_relocation, monterey:       "4ae14bdb818d50308f4f408eda1ce7318075895e9ffe99394e4daf54b8058e42"
    sha256 cellar: :any_skip_relocation, big_sur:        "d48dcbc69ffaaa7c695b4be757961f77c1424223e65b620376733f18107aaf3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d91072611e2a9a14450b910b934891401d437128337533aff807b0521cbd5f"
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
