class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.7.1",
      revision: "53c28e44f10548c8839d4c72e5909fa74e08b5f6"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aada32a3b4ff6c2a9519b740c3150fa16af41e5fdb0a3af43f863f62621c9283"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bb1023b00cdb6b39b130b6dab536c08fcc3763935475745ccd870247a625096"
    sha256 cellar: :any_skip_relocation, monterey:       "afcdc471a6c659468166a8046be6e5e521946e122ed107b59aaf0f1db592491f"
    sha256 cellar: :any_skip_relocation, big_sur:        "55e6a4c45717a1e07bc72388b22e520dd42f9f7bdf7775109841a03efbd057ce"
    sha256 cellar: :any_skip_relocation, catalina:       "7171a0d78571d53c7337827bffb0dd73e1ff0cb742d378aaa571da779b62399e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5acccb4984b6cfb898423b6d4cc284a0a23ad7dd34880074b3418ecb344878b2"
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
