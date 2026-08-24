class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "446d79d978a2b98389c98c97a6f505fb021fefec0532fa55abf0e22e72de2bc4"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52cfa91bb9129ea44a61dc41913624659d1dd487c5d95ff59eec3a9f72105207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14485dcde6782a1f454a645718d6abe96fc530b63458fcd03491fffdf03773aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a202bb5993c6fcb48eb3a1b9332c101df085e7ff2c774f39196a7ccb4758f424"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fafb5f913e766ac59948f57323b1a7bdfadba373324ef22d99fbbfaea80000f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f96e7857948be8c172d08288efa9760c9aa15e489316389f703919c58f3a0b65"
    sha256 cellar: :any,                 x86_64_linux:  "01761d355360052d5e82457bc1c9aec5193a1f86046e556bba87a88709e923b4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
