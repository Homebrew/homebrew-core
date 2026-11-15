class KubectlRookCeph < Formula
  desc "Rook plugin for Ceph management"
  homepage "https://rook.io/"
  url "https://github.com/rook/kubectl-rook-ceph/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "868320447f35b54bc000200b983d82dbd58ff0966734217bab3006034e967331"
  license "Apache-2.0"
  head "https://github.com/rook/kubectl-rook-ceph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3fa7e830abcf481cd9de332c58b1313ad56f09c1f9fa422531c58e6f7dfbc24a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35440c0e2b3a61c22a91707f6e08025ecaed801cba89d4c2b022535b2846f00a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5834107c3dc025f223966851f6dd352be203d9a4ec7a0f947aa9fc3b7d0b1aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b970172d7af7a45a4aaabb31ba26b6212ecee0c0d3715f782979e337b6a87b14"
    sha256 cellar: :any,                 x86_64_linux:      "94cd78c3d2df9ad694cd6545e2b80e2f8617d75acd07c9496f981759f10a9eb7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: "#{bin}/kubectl-rook_ceph"), "./cmd"
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/kubectl-rook_ceph health 2>&1", 1)
      Error: invalid configuration: no configuration has been provided, \
      try setting KUBERNETES_MASTER environment variable
    EOS

    output = shell_output("#{bin}/kubectl-rook_ceph --help")
    assert_match("kubectl rook-ceph provides common management and troubleshooting tools for Ceph", output)
  end
end
