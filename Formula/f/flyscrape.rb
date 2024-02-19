class Flyscrape < Formula
  desc "Standalone and scriptable web scraper"
  homepage "https://flyscrape.com/"
  url "https://github.com/philippta/flyscrape/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "27ba02ba2b64725a197e12fce66fe26fdcac02f48644acdfc8332831cd6010bb"
  license "MPL-2.0"
  head "https://github.com/philippta/flyscrape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21cdcf47c7a9ef03a3a3f69013a4c856cb650078ec5675368edcf5a3ee383e4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3040f4ff57cf5c508ad78aec3ddf4f4784f017cd3174c68d177d38c453f2b30c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a27ff94c294808c6a9548e553edf1b51e79480d6d4e49c7e564f1b011cb4aa3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "373efd6d3cb6628b2aadb33fba8441b1c3a9e5b812d7f4147d2cd31b86c2495e"
    sha256 cellar: :any_skip_relocation, ventura:        "339e1d905c2f6fd079fa3570f2f4b429018efdeb7fac81e402e16e4f22d335a8"
    sha256 cellar: :any_skip_relocation, monterey:       "bc75419ae9fe8da8eb6e74ad311cc95eb7be8b41e37dac4798747c1dd3bcc9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6c6e7c19e338aaae70c2b9d03a03fe514da01e65f898e5a9457e88a37b55519"
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
