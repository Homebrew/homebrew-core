class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.0.1",
      revision: "8faaee4d2b5f65678eb0831a8a3d5990a0271d3a"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2195d4aab739441e8154db30aa679e9d233990808bffe4cd74e21cd6335ee56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2195d4aab739441e8154db30aa679e9d233990808bffe4cd74e21cd6335ee56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acfcfeec3ecb896d459f640554af66ed60e4a55318a8d7c82c7ac05ba86745dd"
    sha256 cellar: :any_skip_relocation, ventura:        "0dddc6de99504ad884a0e8ce4f6d4cd453696761dc26b242cdf2d153a386adcb"
    sha256 cellar: :any_skip_relocation, monterey:       "0f74993621649b9087186f9890c8962ad5ad9e4d20c04f77ae8a8c70b9629497"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae5069412c0de73a172edd1da13f6a0667e2118c92460d4cbed53d7e428a2303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab186f9bc1bd9a85e1490f89f6d1f48bc2d96feb5cd343ec5a55e74431fe9a4"
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
