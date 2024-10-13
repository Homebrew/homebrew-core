class KubectlRookCeph < Formula
  desc "Rook plugin for Ceph management"
  homepage "https://rook.io/"
  url "https://github.com/rook/kubectl-rook-ceph/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "4d2f2b0bab7b809a50534977b3259b845ffac09b59001aadb00cc3499cd341fb"
  license "Apache-2.0"
  head "https://github.com/rook/kubectl-rook-ceph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "306c9ddf98a35df7b5d0c3ef5d585560cb644a9be064dc5f2125a853bf141487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "306c9ddf98a35df7b5d0c3ef5d585560cb644a9be064dc5f2125a853bf141487"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "306c9ddf98a35df7b5d0c3ef5d585560cb644a9be064dc5f2125a853bf141487"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ac03ac7a7ee5f8a05210368354ce02b557f33b8fa55d0ace04fd47bd40f62fa"
    sha256 cellar: :any_skip_relocation, ventura:       "2ac03ac7a7ee5f8a05210368354ce02b557f33b8fa55d0ace04fd47bd40f62fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "713577950801b8272d0e567f423d423200ec1a966ba64cd3c40925dcfd93dafb"
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
