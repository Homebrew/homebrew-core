class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.22.0.tar.gz"
  sha256 "b713695ecc0bde718a0598279236934819c9fb07e3a3978f5499871d02b9898f"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d3f69f822aee908dd9fcc97bf3ee21cff881a4f9869492ef80a4915f5d8c558e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3f69f822aee908dd9fcc97bf3ee21cff881a4f9869492ef80a4915f5d8c558e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d3f69f822aee908dd9fcc97bf3ee21cff881a4f9869492ef80a4915f5d8c558e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37156a3d2aefe8010c124ebb98e751d8d52342bac58ce468ec4fde13fbc9e24a"
    sha256 cellar: :any,                 x86_64_linux:      "b5874ff87284e00bd2cfdd63bdc8a41e17362f4010334d6f0d188fc3ab8e2856"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml sync 2>&1", 1)
    assert_match "confluence base URL should be specified", output
  end
end
