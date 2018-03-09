class Masscan < Formula
  desc "TCP port scanner, scans entire Internet in under 5 minutes"
  homepage "https://github.com/robertdavidgraham/masscan/"
  url "https://github.com/robertdavidgraham/masscan/archive/1.0.5.tar.gz"
  sha256 "a0686929888674892f464014806444d26ded56838d45035221ff88ee9f6ead73"
  head "https://github.com/robertdavidgraham/masscan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97def50fe25a1b352b1808043693e230d6d0ab4a318389dfd68bd4b60e654ec4" => :high_sierra
    sha256 "d2770cd3ff575b998818f5586f182fe626bc336a48542d1c01656fd9617df1ed" => :sierra
    sha256 "8dbe578c48b421e03a264c82912e10009b1b6163f704f3388a017799accaf0a9" => :el_capitan
    sha256 "969e348d0a3738b1fcc5082a6c0feef0f18d1f462b3d9bec0cd1751781b263e3" => :yosemite
  end

  def install
    # Fix `dyld: lazy symbol binding failed: Symbol not found: _clock_gettime`
    # Reported 8 July 2017: https://github.com/robertdavidgraham/masscan/issues/284
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "src/pixie-timer.c", "#elif defined(CLOCK_MONOTONIC)", "#elif defined(NOT_A_MACRO)"
    end

    system "make"
    bin.install "bin/masscan"
  end

  test do
    assert_match(/adapter =/, `#{bin}/masscan --echo | head -n 6 | tail -n 1`)
  end
end
