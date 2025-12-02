class KubectlRookCeph < Formula
  desc "Rook plugin for Ceph management"
  homepage "https://rook.io/"
  url "https://github.com/rook/kubectl-rook-ceph/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "877ca57eeefd44b1776b335dc7ea36d8431c268f37a7b77274e0f286a6e6053e"
  license "Apache-2.0"
  head "https://github.com/rook/kubectl-rook-ceph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c49feed78f61fab9f69789adc602205c3f2fe27567c7902b3a50e1a6a35daa12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c49feed78f61fab9f69789adc602205c3f2fe27567c7902b3a50e1a6a35daa12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c49feed78f61fab9f69789adc602205c3f2fe27567c7902b3a50e1a6a35daa12"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd8066e09c94c045b292558de6418d77f3ba833b4722dee51f8cd95a35eef37f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5a90b3d9ece647a7c2b7479dc4b7ed8369803ad86b3c67dd29e36101c1ddd3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e286057ec852ee1fff033e4904fa1c485c7186dc52bbac039a7ee93b91def35e"
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
