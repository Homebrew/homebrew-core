class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.1.2",
      revision: "193d2153431f8bb0d945a4c1ee721872f73add67"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22bd378b1a707f0ede1521ad0e5805dc2510c41826a6e003548723e2ad639e6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22bd378b1a707f0ede1521ad0e5805dc2510c41826a6e003548723e2ad639e6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22bd378b1a707f0ede1521ad0e5805dc2510c41826a6e003548723e2ad639e6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "de602e30f4a999d27abda283c52048abcbd594873c3dbe104fb62fd93bfac604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4cce87a388384c17b0694389f716253606be61042c67a4b87814efd67296337"
    sha256 cellar: :any,                 x86_64_linux:  "51f5f3ff90cdc7b15024b9514f01a7a7327b01efa72e8291497e8f2fa28b570a"
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

    system "go", "build", *std_go_args(ldflags:), "./cmd/cosign"

    generate_completions_from_executable(bin/"cosign", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_path_exists testpath/"cosign.pub"

    assert_match version.to_s, shell_output("#{bin}/cosign version 2>&1")
  end
end
