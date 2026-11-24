class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.1.5",
      revision: "e5a0818ca5729481095773409e9c1b60cc278e8d"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    manifest_sha256 "b747e1a8e717af4c893e8e0965a94c6e3cc6b4b0344a72a888f18bb5f684a7a1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "276df39b832d3ddfb0bef2b1dad33cd5d4c1a4ecc41ed6e37321aed8da271071"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "276df39b832d3ddfb0bef2b1dad33cd5d4c1a4ecc41ed6e37321aed8da271071"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "276df39b832d3ddfb0bef2b1dad33cd5d4c1a4ecc41ed6e37321aed8da271071"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b2df9deca5363f55ef8dc2d26192612ef0a545315f8035396116c0d3ef63460b"
    sha256 cellar: :any,                 x86_64_linux:      "65f55cf4e3f3a2849d40c1f2b58e8a702bafedc75de8c489945d1ee6746415b8"
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
