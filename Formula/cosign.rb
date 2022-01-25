class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.5.0",
      revision: "757252063bf4724f11a52336ef13a724059a39b6"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4891912111ba73a510272dd9b20f21b4b5b7cbea3c3c3447dc2b32881c928fa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92de695efc5e85b16913436048d1c667694cb266370f7edee8ce3d3c61df7055"
    sha256 cellar: :any_skip_relocation, monterey:       "131df74189f7c2d6f87eaba6862c2a5eef1af9fc1a3f6bbfeda91a6b85e1031e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e41be34de7cdfa1bb2e8532e70264a9f462d6d242f88219b142d80238f902b70"
    sha256 cellar: :any_skip_relocation, catalina:       "4a5a36016e54ad5ea38b7d1f74fec43c0d636fee33b8a4f54736e26df042b9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28b0061ca0903f221cb71d2ccba6ef68b689af1175e5d26c43f6122c761ff564"
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
