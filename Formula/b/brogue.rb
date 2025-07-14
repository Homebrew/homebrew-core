class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  url "https://github.com/tmewett/BrogueCE/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "0fe39782c029068b4d3f9f21cc13974ced56fdd9b192e6ca972f8e13cf726f20"
  license "AGPL-3.0-or-later"
  head "https://github.com/tmewett/BrogueCE.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "b2d2a8e6b65866cfbfba2eea171268017cb44f234dfdd85bd1943b5edcb8827f"
    sha256 arm64_sonoma:   "4d5ec621a099c5016345730c32c48664cab885537d7633f00fa39fe930b905da"
    sha256 arm64_ventura:  "1aec31252a24b39d4be968077507a343210733dfd068f31331e7dc7f5909a3a7"
    sha256 arm64_monterey: "630b47e808445a9b131293d6e5637889d20c7168634981bd557b7df079d8c0d9"
    sha256 sonoma:         "0dc69856645329fa45cd9011a59c84260b00f05ad5fbe2a2e22f0f6ce2544f9b"
    sha256 ventura:        "9c7ee6f9de30fa3507aad6c3fbe863d0c5beea2e06ffdf34774974a83b4903b1"
    sha256 monterey:       "b84fd290fb2f6e5ed03f24df0cf85e0ec4b3c094e9af51271dc8ae2ad23ae0b2"
    sha256 arm64_linux:    "e32ab428d1e157b79b5f8837c820bff2573694ace1cbe4b258ba595171884dc6"
    sha256 x86_64_linux:   "024fae31f907fa7176729178e4b7e442d9f5ea9a978be5bffaa8bf20c5c50006"
  end

  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "ncurses"

  # build patch for sdl_image.h include, remove in next release
  patch do
    url "https://github.com/tmewett/BrogueCE/commit/baff9b5081c60ec3c0117913e419fa05126025db.patch?full_index=1"
    sha256 "7b51b43ca542958cd2051d6edbe8de3cbe73a5f1ac3e0d8e3c9bff99554f877e"
  end

  def install
    system "make", "bin/brogue", "RELEASE=YES", "TERMINAL=YES", "DATADIR=#{libexec}"
    libexec.install "bin/brogue", "bin/keymap.txt", "bin/assets"

    # Use var directory to save highscores and replay files across upgrades
    (bin/"brogue").write <<~SHELL
      #!/bin/bash
      cd "#{var}/brogue" && exec "#{libexec}/brogue" "$@"
    SHELL
  end

  def post_install
    (var/"brogue").mkpath
  end

  def caveats
    <<~EOS
      If you are upgrading from 1.7.2, you need to copy your highscores file:
          cp #{HOMEBREW_PREFIX}/Cellar/#{name}/1.7.2/BrogueHighScores.txt #{var}/brogue/
    EOS
  end

  test do
    system bin/"brogue", "--version"
  end
end
