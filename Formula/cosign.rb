class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.13.1",
      revision: "d1c6336475b4be26bb7fb52d97f56ea0a1767f9f"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9db797820c166d31e74509990e7fae2beb427a83267e1ea4f5958e5f1cb745b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85d58c955810937acaed4b79ffbc8042f8b22581f898e00140f6dc4b36605bdd"
    sha256 cellar: :any_skip_relocation, monterey:       "b6efee3fcc3bc2199bbc2b29f987e4b1953550976766d10c9856ab7a80dae1d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5ac105a08ceb7303ee53572fe430ac2e77f5a058964242ce541bc79a60919c4"
    sha256 cellar: :any_skip_relocation, catalina:       "46d037a899541caf1c37d32f8d559238a443f9130911ae6bbf4ed2fa38ac18cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b6fa0f8287f8bfd194b6c4db5fa45c5ac03d4c1786968dce7f58b5a6b424bf"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cosign"

    generate_completions_from_executable(bin/"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
