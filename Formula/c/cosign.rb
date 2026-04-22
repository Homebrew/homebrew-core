class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.0.6",
      revision: "f1ad3ee952313be5d74a49d67ba0aa8d0d5e351f"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fdbfccfe2271c3d91123578d6ee759b4df5fc87b52206c6a6958c290bd04712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fdbfccfe2271c3d91123578d6ee759b4df5fc87b52206c6a6958c290bd04712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fdbfccfe2271c3d91123578d6ee759b4df5fc87b52206c6a6958c290bd04712"
    sha256 cellar: :any_skip_relocation, sonoma:        "22fb75e2328d601d0d68160d0c40cd75dd3b2d6f5c384b0b6b208c36f57af01c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eb3878feba957a4b585c27c87108e37aa3e35fb04234941ebc86969781d30a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb055876386a02c06c1e5ccaeb76a5f79d9ad8656b74ec1ac0be34d4ea875343"
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
