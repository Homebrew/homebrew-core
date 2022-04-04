class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.19",
      revision: "8fc22630a8b38d52391d276406aa068cada6e253"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e91bd735e6b3c009eea442343e5226fa6ce5e96f34ecdcec73bd07198b849bc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b3ba3710f954295ed82eb42695093381adc15e1cc505c54b9cc678105e5d1c8"
    sha256 cellar: :any_skip_relocation, monterey:       "bd845330f90cd8e86a2ac8e41999d458301ccecc8f5e9c04a7caed3cb2601c4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "87945d0bb568f87f30d28350d3058b0db6453601c546ad39e14a1fc502f294ca"
    sha256 cellar: :any_skip_relocation, catalina:       "8c3fa3686e7e388da03dd2aaff07dff6678a9e99c7f1cbfc0a5a625b2acdf6af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26f6ea11f8df0f08ecf31b0c53579fd3258c1d432006e530381266f6f964661d"
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
