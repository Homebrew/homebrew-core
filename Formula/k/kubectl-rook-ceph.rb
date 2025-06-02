class KubectlRookCeph < Formula
  desc "Rook plugin for Ceph management"
  homepage "https://rook.io/"
  url "https://github.com/rook/kubectl-rook-ceph/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "178b12b7beb225243cdedc7bb43b7ae7b475c9ab365b23f4a785d5a4ff75042f"
  license "Apache-2.0"
  head "https://github.com/rook/kubectl-rook-ceph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66846017ec19f2ad1b58b8124eb7a9ebe8a4974ae2e56258b28ab46d159630e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66846017ec19f2ad1b58b8124eb7a9ebe8a4974ae2e56258b28ab46d159630e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66846017ec19f2ad1b58b8124eb7a9ebe8a4974ae2e56258b28ab46d159630e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "de8ab2a58f43a6ef500d7e1606c56c5a01f946661195e8d739676f50cceb9fc9"
    sha256 cellar: :any_skip_relocation, ventura:       "de8ab2a58f43a6ef500d7e1606c56c5a01f946661195e8d739676f50cceb9fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "417f22e25f795938c98bd6ce4d979aaa043696f3305f4ff2579a9a5d8ff46e61"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: "#{bin}/kubectl-rook_ceph"), "./cmd"
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
