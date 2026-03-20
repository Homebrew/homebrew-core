class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  url "https://github.com/tmewett/BrogueCE/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "2abc186c5327342cb9ad7e45d41096ab10797d5ba76dcac843824ac2a0bfb3ac"
  license "AGPL-3.0-or-later"
  head "https://github.com/tmewett/BrogueCE.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "2858206ccd294ed6b8c3ac136a96c5f5af9815835fba94b10f2378dbff0ce44f"
    sha256 arm64_sequoia: "dcf0b0db0bc9e3e8627f87ca35244787bbd89fe093b05327424f8655f598ab6a"
    sha256 arm64_sonoma:  "47cdc97af85e8b775cb5b62e3e8e7ef61a4059a19d3ec063b5eb36bb22384d59"
    sha256 sonoma:        "42ecd5fdcc6935a1fe4baad309b35a45d777ab9b59d134a47980c934f5800494"
    sha256 arm64_linux:   "996c52eb84ffc7f2e92894ab0a12f9946cc0ff78ace6aec0b0a5926329f4c3a8"
    sha256 x86_64_linux:  "55d19558ca6df95ac0ec02fa3c43160c4e20926948dfa9bfe0b1827c7ca53957"
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
