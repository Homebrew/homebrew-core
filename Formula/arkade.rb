class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.32",
      revision: "b004f9adb0f90c89ef1440f988685fd6b6111d3f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99c1dd2329b0424bd73ed59248f4da5e6437b388c8bff35606ad4b35c096e77e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "708a8543f185ff6fe8f69081d63dc387ea4da5ff78bc823a9b38b6a12f60d6c7"
    sha256 cellar: :any_skip_relocation, monterey:       "6024a6dbcbb9d3fe0c475c20311f2558a33f3d9d317a28f947d4088480e9f255"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce860b71428df5ad54efeb595426a4bf53ba2300229a55c0887197d9f1b8883f"
    sha256 cellar: :any_skip_relocation, catalina:       "eaa363e223006897fedc40b5da49771de77b1c42f172531dde268190927db0d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7081b53ea67c3d218fbc2b4812666417aa1a1d927a400220c51f7cc84a1d1a8"
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
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
