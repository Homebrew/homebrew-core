class Masscan < Formula
  desc "TCP port scanner, scans entire Internet in under 5 minutes"
  homepage "https://github.com/robertdavidgraham/masscan/"
  url "https://github.com/robertdavidgraham/masscan/archive/1.0.4.tar.gz"
  sha256 "51de345f677f46595fc3bd747bfb61bc9ff130adcbec48f3401f8057c8702af9"
  head "https://github.com/robertdavidgraham/masscan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9f5af07a2e4f6f1849e86be73a8e6bca247f87f242921c3ed04421abf2a357d" => :sierra
    sha256 "bb67f591ca801a8e070861f7888983aae0abde5ff74536013049d21b7659ad9a" => :el_capitan
    sha256 "7ca9565d5ab497db0c1ce0963de6aa42259dcd7f87d54f52359cdba53deffd57" => :yosemite
    sha256 "8c2afbee6a71b2e4280d8da97c1c30829477091d6fab7f43dcf8a6890bad520e" => :mavericks
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
