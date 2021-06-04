class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.10",
      revision: "6426ea112f0736d9b81da6dad5b6fa2cfe9b7fed"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4ea772f0f63a2160ed0636c68a50f6233099c9a2114d63cccae109c6e16f459"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a134f57e0ae58e14205af6a12743d70d470ac28d9e711c7d98a34245edc067c"
    sha256 cellar: :any_skip_relocation, catalina:      "6c21fee8471d25db36c45fc047d3c7df9ef6f10415c7eb4e1d74f9d315d13971"
    sha256 cellar: :any_skip_relocation, mojave:        "abdfae1a151e318ebe22c1d1f163843a2efb5c7cc9fcb50510e1a3a5b5cd6a93"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
