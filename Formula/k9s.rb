class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.26.1",
      revision: "e309c28d260b4e9d4b0ea02cfb562126baf9b886"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ac1f746d7c939effea615aca7455aa12ecd7ca9190326f318efbef938560c45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bee026d578b6ae1a8c294ba830f035f3ffbaf9dddea5dd09426f474a5d65c75"
    sha256 cellar: :any_skip_relocation, monterey:       "8d36d712b89f398076b661e453c37d83dde6f85c9e8503172f0e0a8388ee806b"
    sha256 cellar: :any_skip_relocation, big_sur:        "43202d32f23a1be5918a1dabe91dee01aea94ff6e68f5da56fe77a890842704a"
    sha256 cellar: :any_skip_relocation, catalina:       "7619f82b93b8572ae350b8fb4ca2113bf50db64bca8bd4e88ebb8c917cde8b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bb06ae43271f987a4c0ce989b7d5eef4290565209083b9b98f57136df96707a"
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
