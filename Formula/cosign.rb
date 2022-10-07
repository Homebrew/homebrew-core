class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.13.0",
      revision: "6b9820a68e861c91d07b1d0414d150411b60111f"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4959e08a6f063916afbd7e48cc4208b9a389f89c106a7ca8f0ff6ebdb9fccc27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0571ce23241c97441f1d1876f8e022303b17fb6f1a3c5d9a081298897f8235a"
    sha256 cellar: :any_skip_relocation, monterey:       "4c8f2e361f56c83cb8e8802502a36f65780c391542df2c01f066bd3958a49706"
    sha256 cellar: :any_skip_relocation, big_sur:        "62bdf8d9105a1dcde3349cac06d3d8476875ffb4a61ef0a5c0298e470d0d6621"
    sha256 cellar: :any_skip_relocation, catalina:       "b32d2b18b6b4956b09698b69c032633d75dfa19162d5ecd8ad6d8ea69b9d9be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d057fc8d4e4e7a49c48247505d96824a80a49bf53b9d107a96f9cd61b7d5eb86"
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
