class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.0.0",
      revision: "d6b9001f8e6ed745fb845849d623274c897d55f2"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b007ee871d719c1fe2f628bdd27d60c05d2ecde515cca3fc06323c7d5daae25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067fadd587cf4e31c61cedec28fbc70dc5483fb60a4b4c057d259c506e4993b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "067fadd587cf4e31c61cedec28fbc70dc5483fb60a4b4c057d259c506e4993b5"
    sha256 cellar: :any_skip_relocation, ventura:        "305bd4b18fe5ea7bc53a749cf5c7c6c848d59667120024032c22a8f8a5fe41c0"
    sha256 cellar: :any_skip_relocation, monterey:       "7bf9643d938e7ec7d1401c97fd14579d74ad9bf35bd66794a51eb630562b8588"
    sha256 cellar: :any_skip_relocation, big_sur:        "680d5fbce46d1f4fcf11d34ddc4dc3fd4ca86ccf222e9811649c733c482497c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3703460a09438811208aa30de5efdeda2618ad839e0deae3021ab325beff601d"
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
