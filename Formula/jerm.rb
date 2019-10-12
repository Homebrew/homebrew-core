class Jerm < Formula
  desc "Communication terminal through serial and TCP/IP interfaces"
  homepage "https://web.archive.org/web/20160719014241/bsddiary.net/jerm/"
  url "https://web.archive.org/web/20160719014241/bsddiary.net/jerm/jerm-8096.tar.gz"
  mirror "https://dotsrc.dl.osdn.net/osdn/fablib/62057/jerm-8096.tar.gz"
  version "0.8096"
  sha256 "8a63e34a2c6a95a67110a7a39db401f7af75c5c142d86d3ba300a7b19cbcf0e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "679f37e7f92c4eb64a0c94e11e8fc1bdc1b28f3bb7fbefafc38a955318d2f03d" => :catalina
    sha256 "3141c6a52da59f5b0ee5cb514fc797b5979e4ddb4e71b36f56c133ff5311dce8" => :mojave
    sha256 "dd2a0ae44a1aa671a62ccc7461e7550df48d656beeac35b7bc61c732350ece3b" => :high_sierra
    sha256 "ee9a8a2e559bf9ab82ba413e8741759fed6d59cfe82a063c82b72b81a56cfe5e" => :sierra
    sha256 "5c8409bfdeba7b55199659f4b82b8df9ec2ca8685435703bf1ddff29f9e027e5" => :el_capitan
    sha256 "bce73bc0790565d58c129116833c2bf6dab677c95287036f4b3717a02792da12" => :yosemite
    sha256 "e7a2ed29af497e459175ac4b7bf9d4e0b9a367c653ee3d7798b316a95d8e5cbe" => :mavericks
  end

  def install
    system "make", "all"
    bin.install %w[jerm tiocdtr]
    man1.install Dir["*.1"]
  end
end
