class KubectlRookCeph < Formula
  desc "Rook plugin for Ceph management"
  homepage "https://rook.io/"
  url "https://github.com/rook/kubectl-rook-ceph/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "5f7f24006a7b3f2b7a15ec3292272fe6fb7ee4611caebb1324121e806650e449"
  license "Apache-2.0"
  head "https://github.com/rook/kubectl-rook-ceph.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38ef6b6b5600bafd151530f7cd750328fe5ae537e29a8f0256c48c00b888ee51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38ef6b6b5600bafd151530f7cd750328fe5ae537e29a8f0256c48c00b888ee51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38ef6b6b5600bafd151530f7cd750328fe5ae537e29a8f0256c48c00b888ee51"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca5cffd2a78ceed9a0d2777c1eccb1b555e75a23215dbe9d1d42f1fc6d0f5884"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f31f6d9ed0bcf0b233bf2deef70c717b46cc8a232d9ccd26f971fe376298b642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c67ffb743c4d5fb29bfe87cb63617614c1fe094681bf390f937ae17aadeca7cc"
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
