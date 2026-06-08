class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/archive/v1.9.0.tar.gz"
  sha256 "d5253a17ae340b8d8d9afbfb84dde9ae1b63251cd2e195de5f69e6108ba43a81"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "954ffd1d5138bfce2f1e66f393eebe2f154d1ae3d4fd99142abcdbaf316ce9a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "954ffd1d5138bfce2f1e66f393eebe2f154d1ae3d4fd99142abcdbaf316ce9a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "954ffd1d5138bfce2f1e66f393eebe2f154d1ae3d4fd99142abcdbaf316ce9a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfdb3e4fa7f3ccbfbf1fd63fa745e5adcb175bacbcfefbe183fabee98a39391c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53840d3a7c156a62b99b3e6112c66e8872f86c820c3fa3ab89b2d763377b8eb8"
    sha256 cellar: :any,                 x86_64_linux:  "53b683bf5107006e494df354b00ddd037e942e207ff817e4cda8ee54628576a0"
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
