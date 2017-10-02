class Masscan < Formula
  desc "TCP port scanner, scans entire Internet in under 5 minutes"
  homepage "https://github.com/robertdavidgraham/masscan/"
  url "https://github.com/robertdavidgraham/masscan/archive/1.0.4.tar.gz"
  sha256 "51de345f677f46595fc3bd747bfb61bc9ff130adcbec48f3401f8057c8702af9"
  head "https://github.com/robertdavidgraham/masscan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2770cd3ff575b998818f5586f182fe626bc336a48542d1c01656fd9617df1ed" => :sierra
    sha256 "8dbe578c48b421e03a264c82912e10009b1b6163f704f3388a017799accaf0a9" => :el_capitan
    sha256 "969e348d0a3738b1fcc5082a6c0feef0f18d1f462b3d9bec0cd1751781b263e3" => :yosemite
  end

  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://github.com/robertdavidgraham/masscan/pull/282.patch?full_index=1"
      sha256 "0daa190200f5cf3e11e9e1c29ea65e7e8e8c0b13fbeccf9a2319cb166234d684"
    end
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
