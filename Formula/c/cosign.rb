class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.2.0",
      revision: "546f1c5b91ef58d6b034a402d0211d980184a0e5"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6f218b52b221290281f129a82bf097737fb638dfa28d47364cc643287471011"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78dbd9f5066f6898e8581f478d9a5c2ac2e4dfa34f40e24d8b6e743b2dedfc04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb70234f9a49d90e345dfce140f8d3eb9d0642f80d58617128c3c7799dcd0409"
    sha256 cellar: :any_skip_relocation, ventura:        "a90ca99b1c53a31f5fb255e2740f7d5bb00996fb2f846e88752a2ec2128044b0"
    sha256 cellar: :any_skip_relocation, monterey:       "f9132375db866516d17fa2cdf4d227bea7ffddd710d2480d9a2bcb2557f50769"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d877474cc3ef3cc62c321676239a52c35f152a32759216c9c867beb81072e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aab23466f98590e0a353a3da2cd837b1c1d67e8d3540f7fca0882622457df53"
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
