class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.0.5",
      revision: "479147a4df05f31be48aeb2b3a9d32dfc35ba877"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7909fb08cd09e38f7db5067a47087b9d09dc565555b5892364f553dd3bc2c88c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "860244663c3e158fd0bbf55d1fed0c67038601da6721e6676f24b263bf3232ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51c6945a7199b3b48f28767aaad8c789d0a319911c75e8048e88d0235a5c6000"
    sha256 cellar: :any_skip_relocation, sonoma:        "3311cd7b07ed6b5b3fd0ed80200e8017946652360a1e231071b6365eeb1876aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2e490f63c35d60b34ed2c8b7670cc2fef0457b0dc65499358cbf1aa07e2c443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a99a90da3bdc293d6b7bf14f0d889691f17c7527ef961a6bd011ea9320bc76"
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

    generate_completions_from_executable(bin/"cosign", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_path_exists testpath/"cosign.pub"

    assert_match version.to_s, shell_output("#{bin}/cosign version 2>&1")
  end
end
