class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.10.1",
      revision: "a39ce91fadc582e0efce3321744a79ccd3c8b39c"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "911a1c0c2ac8470ad8b372a08879593d9f592fe53b57c5b562bd04776172b588"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a31809b6bc78405d9a50d69480e16dcc2ca6a5bb398903af993665f7c8ea9804"
    sha256 cellar: :any_skip_relocation, monterey:       "c67d928edac24a55dd7e3a2a78274b4a2d20ad3a819b7d416be9cf02d4dddfb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "074b6ff1af64bdab9fec6cf677ff6f99140d9f7828fefbd20d31966cae44ca57"
    sha256 cellar: :any_skip_relocation, catalina:       "b9b88f6d3d369d3fe9c8c34f36db362a0de2d21204c6c376169741cb620beb7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6addca8e649b45190fe13351897e46dbf6490ae52124438c43d3da9d9178ee08"
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
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
