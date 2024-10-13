class Flyscrape < Formula
  desc "Standalone and scriptable web scraper"
  homepage "https://flyscrape.com/"
  url "https://github.com/philippta/flyscrape/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "af8c162e1c34bef994e5f54a2a9d985fb794bbddd9735ce0a0884d944251dd39"
  license "MPL-2.0"
  head "https://github.com/philippta/flyscrape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7501c0365f6a5545e4c0bc95b0a0d8eb47a3361f40bd73f02751409dd059a8d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e79161770c219fdc28c98c0702e5a8edef45957c734799768a1aa76a2963a7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66983affadaa35c25cd051e3f8e89be18ca5e52a2fe961efcbae4589b194c6fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07d059096ef20417a0a5d3d72518c32f842c3d810095c151ba4170996d88e264"
    sha256 cellar: :any_skip_relocation, sonoma:         "bde6c44df06433b8e6e0fda04d70b77fe3b001b73b08e35b12023ff6ab783494"
    sha256 cellar: :any_skip_relocation, ventura:        "caaad8607039c47e8a32c52b1e2c9a0ad21fc456b53033d60f042cea5d2ddcfd"
    sha256 cellar: :any_skip_relocation, monterey:       "a327acda83d6c2aa1fd58104cd454ad88727027c73235e2e20751d521f9866c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abbcdb1e654e4d65ff6231508c99791a41298f8837ec5cb2b81477f089580cf"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  def install
    tags = "osusergo,netgo,sqlite_omit_load_extension"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", tags, "./cmd/flyscrape"

    pkgshare.install "examples"
  end

  test do
    test_config = pkgshare/"examples/hackernews.js"
    return_status = OS.mac? ? 1 : 0
    output = shell_output("#{bin}/flyscrape run #{test_config} 2>&1", return_status)
    expected = if OS.mac?
      "unable to open database file"
    else
      "\"url\": \"https://news.ycombinator.com/\""
    end
    assert_match expected, output
  end
end
