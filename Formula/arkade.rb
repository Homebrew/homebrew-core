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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "832cc6294a053a4373e183c54c5958f1e74ba20e0d7e96405b46073699e739dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc0bded11452fb9ea31d71f53c976d6c285f5a36599ad17bd0772682f835c505"
    sha256 cellar: :any_skip_relocation, monterey:       "568eb682877e53faee69091c849e14ae62f6d6e9798850a0e7ce1c752e703ed7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3129eefd0fe0f4adad516b6078edd034ab372fea30479d38473f90a8bed79031"
    sha256 cellar: :any_skip_relocation, catalina:       "4d2790e7c66140ec6a780bef126acf5275e9a5d29c376b64bb222e311c5aa25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f37ce225c695678c10a30c7440fc9f1871428c270969efbe109253d3b3fb68"
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
