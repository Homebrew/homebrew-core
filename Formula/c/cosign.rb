class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.1.0",
      revision: "d253adffe00042d99e7bd7cdcd1d6d2abc3d750d"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f262f73639aa8cb5557f590d624ca68322a8a99e5d285490bcefd6db82481fcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f262f73639aa8cb5557f590d624ca68322a8a99e5d285490bcefd6db82481fcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f262f73639aa8cb5557f590d624ca68322a8a99e5d285490bcefd6db82481fcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dd2a351f837a8f628dc9f89d3184b4587d133931288718bf98fe40182150b79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45cdc38011caeaa07377f911ddfe301d687fac1b75bf82d5627954c9e1d2a3d1"
    sha256 cellar: :any,                 x86_64_linux:  "1a8bd98d3e7356f27d90fcdd7aa4fdd6a3b7540bcd815c00aa562d8f9b4c87d5"
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
