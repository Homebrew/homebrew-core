class Flyscrape < Formula
  desc "Standalone and scriptable web scraper"
  homepage "https://flyscrape.com/"
  url "https://github.com/philippta/flyscrape/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "af8c162e1c34bef994e5f54a2a9d985fb794bbddd9735ce0a0884d944251dd39"
  license "MPL-2.0"
  head "https://github.com/philippta/flyscrape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "749ae509f5610bed37fa3e7e8b6fdcdc13a9a547f8ecf0a2784b7d4897f77e3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0cd7f3d9776eebe6682138bf7870d9967562ed6490649baca47b7523f40227f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b64274dd5ec5e497fa12b3b05c7b87374aa340b2c3c4a7bdb152c878e5b270b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d56a0e5f63b07cfb60907b5302602b788bb7ed5e5e88381dfd93bef02a13b2b4"
    sha256 cellar: :any_skip_relocation, ventura:        "14a87a05b2462df0822d3139680ada4b2ffaa6d6f247ee331369972a86058bd7"
    sha256 cellar: :any_skip_relocation, monterey:       "cf364c881f88bd2ea25029e77115a2ff28c50a5ffdad2b162af6afb0d533b967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd31d69f9b65460b65443f2cf70d0e6154f75eaad65a5b454e8e71ef608c1079"
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
