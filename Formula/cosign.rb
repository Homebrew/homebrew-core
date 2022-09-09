class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.11.1",
      revision: "b3b6ae25362dc2c92c78abf2370ba0342ee86b2f"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22a461c17af6d5f27b4805eacd863f36f8f6f9cf0020c9b9aba0ac6dc5af71fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae27e25dc5d9f52a183ef6f318e175076781f3f8bf73604c9e7555a43f2ead94"
    sha256 cellar: :any_skip_relocation, monterey:       "7f93fdf8e905664856998dd3cf2ac3fdbee7d306be390c3fda54feea78efcf68"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a7e760f427e3a073c249964a736793243b299865328d66556049af344555db2"
    sha256 cellar: :any_skip_relocation, catalina:       "a8699b89b6afb1b9438444782ef80554bffa5fe778bda85f720d116920aef83a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1402eed37b78efa18f3e42d0536c818d2ff5ef7be6ca58abe977d335475ab925"
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
