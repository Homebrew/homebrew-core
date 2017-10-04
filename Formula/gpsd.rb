class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.17.tar.gz"
  sha256 "68e0dbecfb5831997f8b3d6ba48aed812eb465d8c0089420ab68f9ce4d85e77a"

  bottle do
    cellar :any
    sha256 "a31f50d929e0bd9b7f113c38e4c173a846518b4fba60d846a23f1203a6b994a8" => :high_sierra
    sha256 "885f42ac26896f051d7fd6aee233233e35641564635965b7bde5e674183c9114" => :sierra
    sha256 "67983abcb7de346346850eaaa3e007e2eb5bb25eb2e7fbc275a72781966892b0" => :el_capitan
    sha256 "676e8b9d1bddafc02863e1bdc64262ae09ec8a63e4fc3c1abdd930e6eeb28ee3" => :yosemite
    sha256 "843afd054bb63bc058173cd8a9bfbe529e01e331ae3680bb170406204b16f889" => :mavericks
  end

  depends_on "scons" => :build
  depends_on "libusb" => :optional

  def install
    system "2to3-", "--write", "--fix=print", "SConstruct"
    scons "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    scons "install"
  end
end
