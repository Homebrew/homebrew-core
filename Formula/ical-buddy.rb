class IcalBuddy < Formula
  desc "Get events and tasks from the macOS calendar database"
  homepage "https://hasseg.org/icalBuddy/"
  url "https://github.com/DavidKaluta/icalBuddy64/releases/download/v1.10.1/icalBuddy-v1.10.1.zip"
  sha256 "720a6a3344ce32c2cab7c3d2b686ad8de8d9744b747ac48b275247ed54cb3945"
  head "https://github.com/DavidKaluta/icalBuddy64.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "720a6a3344ce32c2cab7c3d2b686ad8de8d9744b747ac48b275247ed54cb3945" => :catalina
    sha256 "734aa2e1b61ef6d9ef8800ab5382a8e157a13631cf1eeacbbbb0cc80f1831a76" => :mojave
    sha256 "fa01f750eeb692d11ae0fa4cb6131e331446ad623bc8fc284b3721cf81621f39" => :high_sierra
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
