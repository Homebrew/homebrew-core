class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.25.0.tar.gz"
  sha256 "7ff930895198328d84368a4e9b3b2bbec976660058cdab04104f593c22ae0cfd"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9b579a7f5c2f3514f0d5bb169953c150cd5cf5679de9094d54483a7269ebebf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9b579a7f5c2f3514f0d5bb169953c150cd5cf5679de9094d54483a7269ebebf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9b579a7f5c2f3514f0d5bb169953c150cd5cf5679de9094d54483a7269ebebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afe3a7fde24d1e307e68f2c297d4763ae2150408525a55c444af9277e63f7d64"
    sha256 cellar: :any,                 x86_64_linux:      "5a4d91dd888231dc207d11c541572e47858cc534685a19046d567793c3ef631b"
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
