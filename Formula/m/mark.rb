class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v17.4.0.tar.gz"
  sha256 "5499f7950c2ff5523d7b492abd73a24714502178cb6e94352371e7d8a119c909"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9eda93faf5baa704828423ee99767a228184bededa51ee474e8213607c6b185"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9eda93faf5baa704828423ee99767a228184bededa51ee474e8213607c6b185"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9eda93faf5baa704828423ee99767a228184bededa51ee474e8213607c6b185"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f571441bd8d787f6386a76ba74fe79ffd462e90007b9052ca8e0111e8e7f794"
    sha256 cellar: :any,                 x86_64_linux:      "4a74de2cd84b47b2c92e9b30410da1082e33eb15d00098cd46369f1b09338978"
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
