class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.6.0",
      revision: "37fbfc7018fb4d60a9a2c9175bd64c75dda5869a"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30577c6d6f189064c14b9d0581608905dcd697bab11199a7d13a0bf013f21b81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "753831907e4c3545f1775577e5121dadf0e96dc7a947d1e63683a475dfc15fe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f743608b7551914a1e16e86e2fc1464c827825e611a32d0f3cb36798e9a3768"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b3a65a35a772dfd5390bb785eecdc8f0ddfbd680f6e9f3f05abf8142f9f64fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6dcba95b4f010e8d5817b86f9aaa6f91439d63db49ef8578ec16f6b7e040a2e"
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

    generate_completions_from_executable(bin/"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_path_exists testpath/"cosign.pub"

    assert_match version.to_s, shell_output("#{bin}/cosign version 2>&1")
  end
end
