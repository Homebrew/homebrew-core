class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.24",
      revision: "0acde43ee7abf23dc2f0164faad5ccb352cef3a2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3be0e3250eb2e73b67eff35b0709614a24e5ae3acfd20f5f3d15dea8bd0c91f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "203684c5dab4de741a6f931c69eab01b0e95c5a135c8e657cd0902b4838468af"
    sha256 cellar: :any_skip_relocation, monterey:       "a1206ee92e76f89c26949e29418b40fa13932ff7428e4554720b347e62b6bae0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef92e022bc52b161d8c55dec803d52a2e5f6700f894cc28d9c1a83b85a3448bc"
    sha256 cellar: :any_skip_relocation, catalina:       "ae40d5fcbd9ae73469242a6543a94d990c28d081f25843a79f64a97d057689a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c664580afdc5564bf0fa615052798332ebab420e7217b813bbac09ddbb652b7d"
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

    (zsh_completion/"_arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "zsh")
    (bash_completion/"arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "bash")
    (fish_completion/"arkade.fish").write Utils.safe_popen_read(bin/"arkade", "completion", "fish")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef _arkade arkade", "#compdef _arkade arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
