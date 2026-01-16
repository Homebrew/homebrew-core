class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  url "https://github.com/tmewett/BrogueCE/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "0fe39782c029068b4d3f9f21cc13974ced56fdd9b192e6ca972f8e13cf726f20"
  license "AGPL-3.0-or-later"
  head "https://github.com/tmewett/BrogueCE.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "3e1dd9e90a669345ef16c27ef510e3e0ccf2200e8da4f3efbf0a92e5dd1af3e0"
    sha256 arm64_sequoia: "7967fc966d7c139dfb78b937b92b0fb450ecf8a83adeaea333db7e89e1711f78"
    sha256 arm64_sonoma:  "1211a93d5c0cf7b62221dfc15d3dfc0b327ac629efed065f2cd86eab238716b0"
    sha256 sonoma:        "ff9f19efa068b04c6656f13b4d92245867320996d3c75cd395a35ad086e70654"
    sha256 arm64_linux:   "fe2394596cd3dc627deebd97e7d627080614e1677d4d870cafd14b1ebadd011b"
    sha256 x86_64_linux:  "0e6146845d9e59936b44983f2767d45aa90c19d71bb342dd005bbc46c0908bd3"
  end

  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "ncurses"

  def install
    # Use HOMEBREW_PREFIX path to get sdl2_image headers
    sdl_config = HOMEBREW_PREFIX/"bin/sdl2-config"

    system "make", "bin/brogue", "RELEASE=YES", "TERMINAL=YES", "DATADIR=#{libexec}", "SDL_CONFIG=#{sdl_config}"
    libexec.install "bin/brogue", "bin/keymap.txt", "bin/assets"

    # Use var directory to save highscores and replay files across upgrades
    (var/"brogue").mkpath
    (bin/"brogue").write <<~SHELL
      #!/bin/bash
      cd "#{var}/brogue" && exec "#{libexec}/brogue" "$@"
    SHELL
  end

  test do
    system bin/"brogue", "--version"
  end
end
