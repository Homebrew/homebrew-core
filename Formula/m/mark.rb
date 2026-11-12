class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v17.2.0.tar.gz"
  sha256 "d475d8bd891cc0fd5fa1a2cd4d487855c8b51746357d791652a4d1f945b1915d"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a2da5e1b51d41e63877b0774339b44d587efe43dd981033c4ddca919076b507"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a2da5e1b51d41e63877b0774339b44d587efe43dd981033c4ddca919076b507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a2da5e1b51d41e63877b0774339b44d587efe43dd981033c4ddca919076b507"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5c59d2b1e65239a149ccbf975522ddf5fd76ff87437cc06f545318337fd405a7"
    sha256 cellar: :any,                 x86_64_linux:      "85f61ce0438119487c3ad7f35a5cc346f384ae9c225d688bb33f1e6a41917d45"
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
    output = shell_output("#{bin}/mark --config mark.toml publish 2>&1", 1)
    assert_match "confluence base URL should be specified", output
  end
end
