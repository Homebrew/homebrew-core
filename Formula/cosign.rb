class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.1.0",
      revision: "986848fbabf3de9362ec3f538a04d301dbbd579c"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1274e95d3acfc0dba8509297e7874b222e0735cea983f6162df592e62967f5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1274e95d3acfc0dba8509297e7874b222e0735cea983f6162df592e62967f5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1274e95d3acfc0dba8509297e7874b222e0735cea983f6162df592e62967f5b"
    sha256 cellar: :any_skip_relocation, ventura:        "6d02a344d1d674fef34597b8147f2fb93edc123eab77ac9d0743b290edadb866"
    sha256 cellar: :any_skip_relocation, monterey:       "e7ca24119db65f59b6dc5e3cfabb58800db207c0dfa88ac471c41814ffeb7e4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f956d307ec80d97b982cf55e5a98d0dee6cd3535c6e7f83b8fa5b415695fe71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99b2cdb0861856a7f18abf10a8f9cf09c98fcafd13007e49e527197b04f263b"
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

    generate_completions_from_executable(bin/"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
