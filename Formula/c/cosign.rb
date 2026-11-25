class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.1.6",
      revision: "252f10a80ba871152a12e5ee324ad1e02c85d079"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    manifest_sha256 "c19b4d38a9761b8312ba603fb10bdde9dc7243fede31abdc3c589c4e7e72127d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48551a51ac041e96a674992554f393815ba533b5b2cace343c0f32e014d93947"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48551a51ac041e96a674992554f393815ba533b5b2cace343c0f32e014d93947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48551a51ac041e96a674992554f393815ba533b5b2cace343c0f32e014d93947"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3aa3e7d393134b87e3240b70d16e96c8bf0c9cc846ed76d24ab255d9be1d854f"
    sha256 cellar: :any,                 x86_64_linux:      "7cba90acb6001e949e3bf7c4595f326a814b63ad51c6129f8e61ca44ca8c5efc"
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
