class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.13",
      revision: "0d507d0f72224b3b1fa9451d144dbe8c64749b75"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a500a0ae65fe433f1ead75f8970a3a831eafc36c87cc2aa8e6e514bd65e713e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a500a0ae65fe433f1ead75f8970a3a831eafc36c87cc2aa8e6e514bd65e713e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a500a0ae65fe433f1ead75f8970a3a831eafc36c87cc2aa8e6e514bd65e713e5"
    sha256 cellar: :any_skip_relocation, ventura:        "4cbdf160799ee8076862829c123d981253aced5c2c259bc252407ad8f6fe4e29"
    sha256 cellar: :any_skip_relocation, monterey:       "4cbdf160799ee8076862829c123d981253aced5c2c259bc252407ad8f6fe4e29"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cbdf160799ee8076862829c123d981253aced5c2c259bc252407ad8f6fe4e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f1810676b9238cefdc5b404daaa67940c734508dc142f7dfd4a7522665792ae"
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
