class KubectlRookCeph < Formula
  desc "Rook plugin for Ceph management"
  homepage "https://rook.io/"
  url "https://github.com/rook/kubectl-rook-ceph/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "c426695f3345e631ba912923b2105480f3b963ee8fd4311b29685c3de678e169"
  license "Apache-2.0"
  head "https://github.com/rook/kubectl-rook-ceph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b64737ae9d5c44cf8cb94f4de40c80fafbb4f3cd38f4d6d233b4f8486fdff144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b64737ae9d5c44cf8cb94f4de40c80fafbb4f3cd38f4d6d233b4f8486fdff144"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b64737ae9d5c44cf8cb94f4de40c80fafbb4f3cd38f4d6d233b4f8486fdff144"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5e5e5938020925a5153d4bc3b8535334b3d4b32c02d1a184db3243d3bedf06c"
    sha256 cellar: :any_skip_relocation, ventura:       "a5e5e5938020925a5153d4bc3b8535334b3d4b32c02d1a184db3243d3bedf06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13378c8a5004db1dfbb29384d11381d1f90be0e4f19e687800337ddd85d32155"
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
