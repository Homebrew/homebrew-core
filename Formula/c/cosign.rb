class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.1.4",
      revision: "0e48502cf5ef34e2e60bbd3617aa19945712f705"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2099621c47c489b056c108c4bb8812e948b1a1f3f3d357c1d71726b95cec5bad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2099621c47c489b056c108c4bb8812e948b1a1f3f3d357c1d71726b95cec5bad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2099621c47c489b056c108c4bb8812e948b1a1f3f3d357c1d71726b95cec5bad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05adf880a73f558f966887f686c576e17ac0f7e32e9ab16ff983e9c4867103cb"
    sha256 cellar: :any,                 x86_64_linux:      "244270e61f1e9b55adeed61adeb85201272af0b040ebbd76ebbbd063050e756f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
