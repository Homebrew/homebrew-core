class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.1.1",
      revision: "7914231b348c4057891edeb321772aad3ed04fce"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e790a4037d2e95e9a8b7e128bb77b54c48f0b6146114414d85cc447ddb29756c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e790a4037d2e95e9a8b7e128bb77b54c48f0b6146114414d85cc447ddb29756c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e790a4037d2e95e9a8b7e128bb77b54c48f0b6146114414d85cc447ddb29756c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbbfaecc0c28971354d6328e24676ecb74fa7ad3002cc1671d33867947c62bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7043d1d71b84829ab85007c61e00e806e88190eba876995687cdc1bc321b7ea3"
    sha256 cellar: :any,                 x86_64_linux:  "0dc328b3860327ea18b89b3a2e1ec772a0f1e458e865d51c1e38cb4c60e3ce58"
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
