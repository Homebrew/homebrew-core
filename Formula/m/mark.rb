class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.17.1.tar.gz"
  sha256 "80b742f893b28bd72b04f9ee9d8deadfb90001ab5b24afad699018d613e27913"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "011080d8e61c265f3e01d320fbed427814039a6af095820f39a603f26e1a660f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "011080d8e61c265f3e01d320fbed427814039a6af095820f39a603f26e1a660f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "011080d8e61c265f3e01d320fbed427814039a6af095820f39a603f26e1a660f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e74bed50e5800649eab72624d582fd4c2c28266269dfa82112b0cb0549c13260"
    sha256 cellar: :any,                 x86_64_linux:  "cf2206f67f0e608b4c32ab99dcb89666121fa950cea15a7feee068036c368cb2"
  end

  depends_on "go" => :build

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
    assert_match "confluence password should be specified", output
  end
end
