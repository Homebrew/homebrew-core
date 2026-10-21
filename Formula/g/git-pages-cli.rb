class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/releases/download/v1.11.3/git-pages-cli-src.zip"
  sha256 "b100f0501de475088ad4fbd64f9bc3b77b2d179de3c26b3838b240bf32c70d73"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "475a5f7982d07537921f3df873676eed99de1db438c8d34f0e34a6c346837368"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "475a5f7982d07537921f3df873676eed99de1db438c8d34f0e34a6c346837368"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "475a5f7982d07537921f3df873676eed99de1db438c8d34f0e34a6c346837368"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ea59393bf04bf64b7761a23f0d9ba7139919f4990b0ae796c45733a57792240"
    sha256 cellar: :any,                 x86_64_linux:      "7dd7e7a3b589a6bad6e81db6effff4e942e43f5a244315413be2152007b6636f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.versionOverride=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-pages-cli --version")

    output = shell_output("#{bin}/git-pages-cli https://example.org --challenge 2>&1")
    assert_match "_git-pages-challenge.example.org", output
  end
end
