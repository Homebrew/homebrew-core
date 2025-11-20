class Esniper < Formula
  desc "Snipe eBay auctions from the command-line"
  homepage "https://sourceforge.net/projects/esniper/"
  url "https://downloads.sourceforge.net/project/esniper/esniper/2.35.0/esniper-2-35-0.tgz"
  version "2.35.0"
  sha256 "a93d4533e31640554f2e430ac76b43e73a50ed6d721511066020712ac8923c12"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0009b1cbccaa056103dc110ff59bd1bebc1f2581bf91b64ffd5aee76009efda8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3ffcb434110b0fb16092defe371f445e592abc9119d56a2204bad258d266c6e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8be6a449287ddf6ad663e87c7fc8115dd7912f8311e6ecf5ee5d1c2f4b3d1f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bb981e2a11b1963ecba800ea00ec07647d3f5f6d4d90986e512e8e4a72dd422"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a00cc8d55d37e3b20069a08176bfea366e64bae3ab651fe7063f857610a36ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6db787246047b9a9796d704b258f7f3c7a8f0d35eb77ea4eb5d766ee1c67895f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3b3829d27213eedbd1d088f1037ee95976ab02f910a1a9479d91cebc1db53e3"
    sha256 cellar: :any_skip_relocation, ventura:        "5fff65a1cec7ac2bbaaa5cc849cd61a4e795f589ee5f0ea6231f405841eb4a06"
    sha256 cellar: :any_skip_relocation, monterey:       "99e0e6b314a7990401afdd12fe220bd78e8773eb5803a6c308cd658c88114013"
    sha256 cellar: :any_skip_relocation, big_sur:        "8533d8f2e0a0e4cafbc9f3305db9cd5eccdcdd0651d7bc8f8331b625395c1aab"
    sha256 cellar: :any_skip_relocation, catalina:       "609f0b7d7331c4e61d274a83cbfc7157394d905a5840c6df7547140b5b0a44da"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d51c39d3d114d8ed2a5dfa939ed50bcdf0df86ee908691a9113c92447ecb598f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "676227a142bc96ca566a352c446328a78c7ad02bb80b56e3f3f131e755994a31"
  end

  uses_from_macos "curl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
