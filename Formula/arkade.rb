class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.18",
      revision: "f8a4add41fb0c2141147c52b6485ffbfa93f3aa3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35399dcfac9af26cfe40f68b3afb35a7deeb1ea78c14258c3862b1ea9f6b0d9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4580084bc222ac4a8f35a02a484a48567e26f322eb1008e277f0c42b902e16fe"
    sha256 cellar: :any_skip_relocation, monterey:       "1167bf1f8d9e524ef5f3b58d9de7618fd2b6a30d504606cdbb17129b91c19809"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f186d3a9956d3f02be5b55c177c275fd87761fad0ebc63fd5644eb878cd9d8d"
    sha256 cellar: :any_skip_relocation, catalina:       "7b1a360df115603f09f47f8f477daf04e02153f41b9c714450471f03c4c16ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f787e11d0d263d08660aa15730ccf5e4f30d0edda9e7edd7f0419c5ffc4ffb1c"
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
