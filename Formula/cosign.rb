class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.5.1",
      revision: "c3e4d8b7cd2f6f065941510b260f173b70c695fa"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eceb8b9d8ebdb70db03a3682ddd45dfa53235cf7da94e8db773c1f6116cd9ffd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b8374f2c3c8d3ae14c6c77b9c9f420c78a3c12f43d2986a60e80f2853a975ad"
    sha256 cellar: :any_skip_relocation, monterey:       "8bceb36d563dc2c2a6c5712c2dfef62049a2b8299431d2f7579ba205ac08a926"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7ebbe18baaebb104bd18a69adeb846453cf61859ba573564146680e6cf34f5f"
    sha256 cellar: :any_skip_relocation, catalina:       "0807128c6ddbc38a1430cca6f5ccee9681361e3784a76ef542aa85e514ee0f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c327d8a849f32d62588cd0a090b75f5cc0d34cf68eed8d3b2289d4469cf11b8"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/sigstore/cosign/pkg/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.GitVersion=#{version}
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

    assert_match version.to_s, shell_output(bin/"cosign version")
  end
end
