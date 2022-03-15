class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v2.0.0",
      revision: "ff9d30b7a07ed2219b0c82f1946307dbcc76975b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ac9dfd34d27cf27477454c1951cd3fd224321c2e0839a1cf652c7f70354c78d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8157398cf8a15778435bce1b33b4fc7476a0910e3feca058d2d0117cd3c13432"
    sha256 cellar: :any_skip_relocation, monterey:       "ac42a1034fe7d370d249264bbf8d7ec781631896bc715d0d2250f9fa4416ee90"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cf0b1bcb708ecca28a216e8917e8189ad6bd50a44e51dac338df0ef73100d30"
    sha256 cellar: :any_skip_relocation, catalina:       "471957acddb20d7ff1c31cbbdced6dae3ebbd3a73e87004dfaff4742a3c84d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d94667b2cfae8f37e5e21882310b4ebf54c7291a3507359bcc73041ac9f2f121"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubesphere/kubekey/version.version=v#{version}
      -X github.com/kubesphere/kubekey/version.gitCommit=#{Utils.git_head}
      -X github.com/kubesphere/kubekey/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kk"), "./cmd"

    (zsh_completion/"_kk").write Utils.safe_popen_read(bin/"kk", "completion", "--type", "zsh")
    (bash_completion/"kk").write Utils.safe_popen_read(bin/"kk", "completion", "--type", "bash")
  end

  test do
    version_output = shell_output(bin/"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_predicate testpath/"homebrew.yaml", :exist?
  end
end
