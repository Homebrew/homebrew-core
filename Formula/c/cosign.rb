class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.6.1",
      revision: "634fabe54f9fbbab55d821a83ba93b2d25bdba5f"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52aac7a0ae6d6a529cca6d1378b2722a32e17c39db54dd08f61af909be87d3d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc84e55a20557dae41988b343fa374b37337d0ac335e7c17e31594db11fd9869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ef0fe8492c50c170361cf1deffab41cce858fe8d1e3d963ba5aaba6444b5ec7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cb20d944a38fa15067f4f691d9632783d414e6499f8fd499c91ef6dff008bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea17009b7c4bf6b193f727cf3e78dd19c0dab9468e20786b171d94002e77f950"
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
