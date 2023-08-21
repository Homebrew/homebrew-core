class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.1.1",
      revision: "baf97ccb4926ed09c8f204b537dc0ee77b60d043"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0bd4b24fdaac8bdcd953dba37bf4a6095a242080ef3f41113b2607143fbefb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0bd4b24fdaac8bdcd953dba37bf4a6095a242080ef3f41113b2607143fbefb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0bd4b24fdaac8bdcd953dba37bf4a6095a242080ef3f41113b2607143fbefb2"
    sha256 cellar: :any_skip_relocation, ventura:        "607ca3c712b2da173946a586c73346c5c1af279e51add32ef3dd4b70341e5473"
    sha256 cellar: :any_skip_relocation, monterey:       "e23dec10f6f6e8f747e1aaf2767a0aa6e67ead5df194e3401f3c0992d13380f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a5f7d30a7a7af9e6988c28ce394b238c3f8b0ec1eec4bdc3faa31e211ee7bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16b8466b66123eb4bb56816578c95738fa815e9e5f254ccb909a133213f9d850"
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
