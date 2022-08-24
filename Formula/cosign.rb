class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.11.1",
      revision: "b3b6ae25362dc2c92c78abf2370ba0342ee86b2f"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88311134c95a81c176151f850f9d0ab8ff5f320463223a285a5b2a32e5b2ac7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae3ebababa66a6289658a99e26c3ff9a145aff479e01ff45803e7d0c900d76d3"
    sha256 cellar: :any_skip_relocation, monterey:       "721dd12e70950f238c3b4457166c1bceb1872caccbd8e2f725922efa7b22c3de"
    sha256 cellar: :any_skip_relocation, big_sur:        "33035bf0c6c1365a0844b8c8cce7c08fb4606244b146a9749240ff168ecc7255"
    sha256 cellar: :any_skip_relocation, catalina:       "384758c8815804598fd7faeae33b6afd8cca488fb73942bf74cde67add4d23dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a6932643ede3fc1f7df5b684cb2640886c12ff9c82d40f1233e9baafefdb46"
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
