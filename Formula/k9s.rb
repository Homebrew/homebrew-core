class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.10",
      revision: "e64dcbcbdc35b60edc37cc8753ff7023e1a6bf18"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9de213145e78eff4e54b0d96da82560ab8e3a22da37be82c6a1a977ebba0ad16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1222fa18124480b1071fa8df2938a2e953e5730dd62709f6a35bdb33e96a27c4"
    sha256 cellar: :any_skip_relocation, monterey:       "b9a1fb8bac4a07f2523e13ca0fcdf03515398016c4f85cbea9959b3eaa2d72aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4961b5903b523ecb6af256a1017a0169b5b702a55b4148f285177bbd64f94971"
    sha256 cellar: :any_skip_relocation, catalina:       "8a5fb8849cea7226573078fca78d102dbd61bbfe27cc23aae5ff543e581ba0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d4eb6088982e5a7e9a6ca463e790d2e0fcebbc2c6286af00e3727d64e49f26b"
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
