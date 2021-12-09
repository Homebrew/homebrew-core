class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.4.0",
      revision: "50315fcc82a3d07d6983515bbfa0f2a6c39f7c31"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78ce5bd3d16341fa458818e04477f6498821e2507a18a544104a2ccafa730510"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd8cc9db136a4d184443c3de9df2b61d264959fb11685e4078195c38f9a42cce"
    sha256 cellar: :any_skip_relocation, monterey:       "9de5949c6d522b3dfa63c142ab4ee20d4aed83fd8cfc03fa3ac76564f97d5b1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5404823836dbdada4eecc9548a077235fb769f454921411e882bebf0467e7261"
    sha256 cellar: :any_skip_relocation, catalina:       "8da7d120e02dd43c4cb9882811d3a2574921ac455671a3858b9cec31d0702888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b246f2b35b2d44f7de0718d61a134dfd912ba1bcd3489bfcb53132a4c0e6e399"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/sigstore/cosign/pkg/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.GitVersion=#{version}
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

    assert_match version.to_s, shell_output(bin/"cosign version")
  end
end
