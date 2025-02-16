class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.4.2",
      revision: "b6df9c777c365ce063a7e65075f2b08a3c76de2f"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bddfdbed6941fbd2f396f4eb972bb9b7ce922f6776b569c8230fd60ab788bf65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bddfdbed6941fbd2f396f4eb972bb9b7ce922f6776b569c8230fd60ab788bf65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bddfdbed6941fbd2f396f4eb972bb9b7ce922f6776b569c8230fd60ab788bf65"
    sha256 cellar: :any_skip_relocation, sonoma:        "f21538becb1c17f045b6a857d63f0da2be921e3d2931e0271c2a87539fd140ce"
    sha256 cellar: :any_skip_relocation, ventura:       "3c16d1bb2d566003d6a0fc39a2cfc68b51e216bff6ea4f7f8b02ad5fd63db356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b84b453d11a6ab2711487e31cc5687e8e5b064a6ae2b619437d5aeb69501939d"
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

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
