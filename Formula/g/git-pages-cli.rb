class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/archive/v1.10.0.tar.gz"
  sha256 "0ac04e1dd03a3d3325c6332e28f392c8e89911b297aca44bffc1439f1c60a478"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a9b102ce734487642e1a72048e352049e1541891e0a9e1aa08fd0dabfe964b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a9b102ce734487642e1a72048e352049e1541891e0a9e1aa08fd0dabfe964b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a9b102ce734487642e1a72048e352049e1541891e0a9e1aa08fd0dabfe964b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "962544724de126b4d8d69f2ca9e8d591fe2622a407aa67360f9f2df829ff9b3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dce74feddd89d3cd2239dbfd6515c6be901d151666ace68f33ac3839fa0fc900"
    sha256 cellar: :any,                 x86_64_linux:  "d165d0bec2a8082a5f1972a41ce15f7523f769d154a446005c826c7f61b13dc6"
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
