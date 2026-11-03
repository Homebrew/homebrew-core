class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.349.0.tar.gz"
  sha256 "af6299144a8ff375eaf5008f6f15a7c9d10602d23ad6a6e45ad818f8ad58f05c"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9e61132b0c7700f53930667889b0b57d39967731d0051ddda55f3574fb5d306"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4ce4c02c2eae163a010db4b41fcfdd1981e3f65c922025a6b73efce94c11bf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7381669bbe3f5bf7290bab7ac0895368baf227a72eacb9deb414046aa1c20669"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5831f91f81214aac9fb9840320b53757d6c0c90e7ba7474ac3e162a2a07d7cbc"
    sha256 cellar: :any,                 x86_64_linux:      "56b08dca4b89b06868759687200aa5433c3972b033c06041d4db6d2d74076837"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
