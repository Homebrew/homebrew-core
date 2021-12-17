class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.15",
      revision: "df613ec88d2d77d5b6e8804ceca959a544218391"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1087c0857f1875ba3f5c879b5d603b6a349a9b5ac605d6a3d829c70961a39cac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e34d0e6309c8e7104fc5234aac51365694506504a0066f553cdee8ec3e5d4222"
    sha256 cellar: :any_skip_relocation, monterey:       "a29628e77275730012147e652b21d00aecea3705c0e3fd9b1ee3e5f75f76aeb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0566a435ea34dd8c1b8595bef78b00b6d704a1bbb0f10868707518f5437e1df7"
    sha256 cellar: :any_skip_relocation, catalina:       "b14c1e21966a34ee0cf046c833b41cbc357f6ef796f4aad55702ccf11d7b145d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59505d31bc904487d8b73d12557bcf21736aceb2627d7fafe9430ca1d1a830f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"k9s", "completion", "bash")
    (bash_completion/"k9s").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"k9s", "completion", "zsh")
    (zsh_completion/"_k9s").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"k9s", "completion", "fish")
    (fish_completion/"k9s.fish").write fish_output
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
