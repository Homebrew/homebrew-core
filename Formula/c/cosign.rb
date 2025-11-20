class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.0.2",
      revision: "84449696f0658a5ef5f2abba87fdd3f8b17ca1be"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3dde83c263a87a98a67686edeb287e53faedaac9fd5188ba03b9b22f47d84d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb0297b357500987bc8917e99463eaebb96db64b1886f66f5294bda83f2f3f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f86385cce585dd213d5be6ecd7be138f4fb93e21985dcb9b103991ce6f62b12"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e2a743b73c998651ad33d7dcc8fd8cdc3153266481009a67c99d7a2ce41fc1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c3805e3ab0d025c34ac4fcf72933801d7943c35c620988e3221c54f53fa5bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e397f86eef678c27cab993b67aa18ee9e94394edd2faf39fff12cbede91c360"
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

    generate_completions_from_executable(bin/"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_path_exists testpath/"cosign.pub"

    assert_match version.to_s, shell_output("#{bin}/cosign version 2>&1")
  end
end
