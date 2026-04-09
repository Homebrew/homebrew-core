class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/archive/v1.8.0.tar.gz"
  sha256 "e20c807fb781fa385c9430eda1173ac2e1d1d22b36108b19bc9b43285341df81"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cdc501515dc4dd308a93c962ae70111d37ba20635eedbfdbcc2f7db2a8b1abe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cdc501515dc4dd308a93c962ae70111d37ba20635eedbfdbcc2f7db2a8b1abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cdc501515dc4dd308a93c962ae70111d37ba20635eedbfdbcc2f7db2a8b1abe"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b69804391f4e12954b7c36ecd378de5db44a6c54c95ff3980ecc75e85cebfa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1003a717c0d4b252ad3c6008ef145b6bbffe1725d8c6b68a78d567802f9fc16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03f2e817006428ec2b13914eb043246ddbe938a95bb15a74f057642183c9b2a4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionOverride=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-pages-cli --version")

    output = shell_output("#{bin}/git-pages-cli https://example.org --challenge 2>&1")
    assert_match "_git-pages-challenge.example.org", output
  end
end
