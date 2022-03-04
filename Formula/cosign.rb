class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.6.0",
      revision: "4b2c3c0c8ee97f31b9dac3859b40e0a48b8648ee"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf6bf13ea5ef545cdf05c10a0e6f021d85da5e2a4efcbce63e879d3a6bd990dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f764f530e79a4de7725263cf351b98db5a4cd2fb93209494c196af9c71207edd"
    sha256 cellar: :any_skip_relocation, monterey:       "ccf12e9f9a04398634427c95d9761e3193dad4f25eea4d1f27843e7acc8e6696"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a8f2d4820c6ca51f22d37b83d2be43808d2b2c506ae1161dd2dbe7ddf70b0d4"
    sha256 cellar: :any_skip_relocation, catalina:       "62417016d4e8d1106e9a51d951b805d7ef8da07be5ccad73e46669ac884d7138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31ec427605f7d900ff909baae6b3bc0a664b87dad54eafce6630e14f847854f9"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cosign"
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
