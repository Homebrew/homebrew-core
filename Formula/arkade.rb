class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.22",
      revision: "2d3df2c8eb2ea261aee0f13bf6c7550a5c41750c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99dfeea85a7dad0c4df2369dad14a8c6586d7810079c70c61cbc4171f21c7f2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d6a3768c7f1abfeb60b33c52f9a819608c03ba0f554ab2a58ab7c309fba5b57"
    sha256 cellar: :any_skip_relocation, monterey:       "e33c9fd12ab8be3205137e3e95556ed2f630a2cccc370a3519e4d70bfb08ddfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "dba712cc609e9733b188ab0102a21b65959b5693876ec2f0c88ac5540cc4796a"
    sha256 cellar: :any_skip_relocation, catalina:       "5a161eabd727b8d9de0c612497c418905e3d5838fe5ca3e00cc5e6c44b4096f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bc30fe0946d302bc5de4769af35d9897c7f61f1f35b3c5c25418c908b191729"
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
