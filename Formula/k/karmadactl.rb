class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "18a591c81b3e30356bdfee766ef41b70934cde04eb04a16a7539d656e20f849d"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d14e02b7ff8fe51bbdacc881a811a3322c5c6f3fd2b4fe0230d42951ae43b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c41c8124edb28cd40d595c5cc5d14c1ace4afc7dc887c82f88e1f97ab2200a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b9145d2987ffa0c3e7361de90a8ee832aeb919199d29697a9a70a468b194ad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "86d05e2fd22d06d9090c12c05364eefa7d9d5f582c5659a52cc113378536197d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5402f9b9851b85279f1a2848f54388ea0f83b4f6a2b18b1bb62db41d1475fbd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96d14665627931d37c7598613db2b5840746f23cef448d20602d3c598c35d791"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
