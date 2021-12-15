class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.12",
      revision: "01bdc850205a450a6a34705bbde3b05e470a730b"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "589845aef33d793ec217a4bbd24bab2f5a0966c496c63d655cb521c52db61195"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f9a58bf3065bca351325788d5914c71d3e62d934bcf8307bc773ebd68e4e385"
    sha256 cellar: :any_skip_relocation, monterey:       "d1c001aba1a66c878882bdbe9b04cd03270933d688cf891e944177d52fa1adcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9180c080f0c8b7dbd8650010f4e7c5965d90ab345f3150a0c98724b8406852c2"
    sha256 cellar: :any_skip_relocation, catalina:       "630797655446bbced141a3288fcad89521e71c0007063cfb5c82d9b3c301d128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8339e3c4e0bfac24b13a6087e6d9fab56714eb063044fbc28977c252fb028b32"
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
