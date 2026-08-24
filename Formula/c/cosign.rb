class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.1.3",
      revision: "11926fa5bbbbde47e88fc006b625a17769b743b2"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a945ba6dbde67cfc2a079b21e74875e2cbd3dcd46b190a64878fb7c08a84431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a945ba6dbde67cfc2a079b21e74875e2cbd3dcd46b190a64878fb7c08a84431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a945ba6dbde67cfc2a079b21e74875e2cbd3dcd46b190a64878fb7c08a84431"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ad7d41284b44486c19adc12f96201c36638f5edcd73d07b5fa2385b38774d18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1729b9ae1608e63f92786b59332ad0d2a58ee3eb719af943b354cf04381944eb"
    sha256 cellar: :any,                 x86_64_linux:  "ec952c936a5a3c70afabbc9cd9be14385bca6b57063c1e195a359ed95945757a"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
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
