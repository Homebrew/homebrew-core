class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.11.13",
      revision: "1ea9ef18597e15c0aff4d91930fde89e825762b3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a3b13913d4034ed6cf95172d855b5941bf4c4eea7b075cff5521fba49475297"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14a8dde1668adbdaca37376eebc64b3083dd7473a53615615a570a1df3240183"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "924aef02f142c911f98162249289ef47df95b8134399e225138a1b8817a99aeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "47ae681a83f2ba0ccd342c9a877ce3d5a88415238ed6b8d92e41cb82ad962c79"
    sha256 cellar: :any_skip_relocation, ventura:        "3b652f7666aed744069fc835de5cd88b662832ac613161bdb28fe6423ffce77a"
    sha256 cellar: :any_skip_relocation, monterey:       "4a8cd52adda0a911c69471205244e805ce14f5fc0dbe386ff23e81bd6b367ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "606ed04f4f2714e71e9d9b0a1483ed5813f27e004690042618bc160bbd54e313"
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
