class IcalBuddy < Formula
  desc "Get events and tasks from the macOS calendar database"
  homepage "http://hasseg.org/icalBuddy/"
  head "https://github.com/ali-rantakari/icalBuddy.git"
  url "https://github.com/ali-rantakari/icalBuddy/archive/v1.8.10.tar.gz"
  sha256 "3fb50cffd305ed6ac0ebb479e04ff254074ee5e4b1a1c279bd24c3cc56bcccb0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8dc7ef559702a3c489b2905e5cfdd4c9be18decd9557c9034df920f0ef57761e" => :sierra
    sha256 "1603d15b5b643a25c98baebc7c7e799bf3176a74a139a3f5dfecb474daf9037d" => :el_capitan
    sha256 "b839dc603deeeaba18efd2c6704e174fc4593fbc4c100c8d655b70f327802407" => :yosemite
    sha256 "44b1bb23023bf91a055f77232b0f2cdb2ad64dc389224a480e2236b308abf9a7" => :mavericks
  end

  def install
    args = %W[icalBuddy icalBuddy.1 icalBuddyLocalization.1
              icalBuddyConfig.1 COMPILER=#{ENV.cc}]
    system "make", *args
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
