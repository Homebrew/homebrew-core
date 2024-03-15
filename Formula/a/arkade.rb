class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.11.6",
      revision: "acb1bd999ac81840fbbe49f3d1cc1fbd386f7fd4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1930d0ac759acdcca8b6a140af97e905a82f163e996ca117becfdfac45f36bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75f1ef5774e3a7de91d48368fe25d613f64942cf0c77b686852db97bb0cfacec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80394d0e3c7d542c7fb8478c4000bcbb4dc5c1e7315fed066c0fc795d0af6734"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bc3f819cbe1eb46094997da2c67560eb2767f804aa9dd381bb8434271d3b1a2"
    sha256 cellar: :any_skip_relocation, ventura:        "9bc0de68da842b3352d6af6f3a003a091deabc7bdeca85f2334292e0b923649b"
    sha256 cellar: :any_skip_relocation, monterey:       "3eed49d3757bb997e048c28f63a5e9aa0382eecdd6a9c3393ff3a49dde581d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c2fadeeb0680638206c2c2764e518766b53b8be935688899ae27812745dff4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

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
