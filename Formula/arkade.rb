class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.12",
      revision: "fda8a74d6a8ee80f135cdd6474ed2fdcb1ed3bcc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78ffbb8bdc72b0ab92f5100e841a693c71fdaf7ff18b726c18aa37c12addfc82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "903dfb939042af9121395267dd58f539a6f3d4293a7c62f25eaf7d70da977eac"
    sha256 cellar: :any_skip_relocation, monterey:       "40762da65ad2ecb2a7c25ab63b0aff8c506d6b29f3fb88ddd63823334369bf0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "18b4b98751c6ce41d0073d4dcdd9fc6875cb44a942174d25083df099cae69acb"
    sha256 cellar: :any_skip_relocation, catalina:       "373d87d266a29b3afd83c8679209a9ef688956a2a7738876e70aa99e989dd7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c94fc6ec5d049d0399e2274b898b0e26e6447178d692743f00806c0f7a67645"
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
