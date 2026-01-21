class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v15.3.0.tar.gz"
  sha256 "bd2052f54a3e2ae4c1df8b333784f9b6d4adf13268dd0694fd130ecc6e57f21f"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71c98a2e63139e0f793c6dc515a4ad96cccca6ce37c4b430483428ef523d316f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71c98a2e63139e0f793c6dc515a4ad96cccca6ce37c4b430483428ef523d316f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71c98a2e63139e0f793c6dc515a4ad96cccca6ce37c4b430483428ef523d316f"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e4478907c0fdc19c8253d56923ad2f07c26380a62e196a3b82d81e79a454e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d81d5f9a47fe725d0547585bdbebefecaf1ebb11afdae3d500569ededb3100cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa226f6ed1ce070f1d6f30f6e061695c81b02778bcdea3f65b7bb17770de64b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "FATAL confluence password should be specified", output
  end
end
