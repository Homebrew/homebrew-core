class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v2.0.9.tar.gz"
  sha256 "3a83671c77e6040ada89f8a53e7cca566b67cc9a2b2c788d2f1d782f365adbf4"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c4330bc568a051aebfa06aff3210ce2ce8ff2f9e32460d107ad064282e722ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de3e33cbb1e861d60b6ef6e0e1711297be0f68110388d8c766f7fcbeaa52dd2c"
    sha256 cellar: :any_skip_relocation, monterey:       "9660714535c33fd6a322d0ea3d6a825697e8dbd816e397a843636f37015f257d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e1606b2462ba3c3b47f47589e0c6a5dac36c0f8557a50b2c3b3441239be9949"
    sha256 cellar: :any_skip_relocation, catalina:       "d0e528c607348bb37cb7a856516088ed6607cd36da5bd208b102e047c5d4bd77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29f6260b4fc9161e3ef840a98432fb78031a14bc36361e35f5532c189c0ea3d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gau"
  end

  test do
    output = shell_output("#{bin}/gau --providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
