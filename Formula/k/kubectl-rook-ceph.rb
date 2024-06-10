class KubectlRookCeph < Formula
  desc "Rook plugin for Ceph management"
  homepage "https://rook.io/"
  url "https://github.com/rook/kubectl-rook-ceph/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "27ff420d86fb8822905ab0b9821ed17262125b3b962e3d15b02546b92c8d157d"
  license "Apache-2.0"
  head "https://github.com/rook/kubectl-rook-ceph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5d9ef1fc6603a1ac9e2823c02b49458a69d340b76e732dc88698e5b739b23fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd5473805a41e83e03f37f2570381c19c43d2090ccdb0ac1cde84de9c3f1e8cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdb2b156ea505f4a74220fae83e6184a4b8c380a079f347a674c27b3cf781b10"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2259fd18b28e1bc9935c74740a8c8892880e96a6d855c1d11a07ae7fba4832d"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b43ee0256862a9ee5116dce142729393479471f0e74264e1c4209e3eb7c9b4"
    sha256 cellar: :any_skip_relocation, monterey:       "3a1093e23e820a9510726126f37aed3dc5988572b7104e1842325ff4f2ce983b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d25795dcad79630e16f25f7004779f11400686b7f8c4ecc5799a727eac0a6d0f"
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
