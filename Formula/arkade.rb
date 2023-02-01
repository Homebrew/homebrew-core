class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.61",
      revision: "995b69f9c7aef7f1d851d57be60262d128ee8e65"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e10bb5ee7a4e8e3fc9171f8025144acc52698e2904624931bfe1e30ba9694388"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10888b1dbe123f851987ff4c9bc164e90ed42b5173003088ef0a1d02623728ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f290d2c78b52b18b203a19690f685ea891a4697e75ab1223920b66a4a1db51d2"
    sha256 cellar: :any_skip_relocation, ventura:        "6de3953b0a0428c0d4779c8f6ac95135547468e1b5d2bca9c0f779443eb7b816"
    sha256 cellar: :any_skip_relocation, monterey:       "222a113c7c900ca67d72e9bf7c7353906d3951beb463992a90cb0222899307e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7f9f2dbe479f0e4c531a79b0d7952f9571c98e87b3705c5b44cad5e963ecc12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "257486e27649a73af41ba5994dd8bf8340288534fbb0e5cbd6fd44d86fbb88c9"
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
