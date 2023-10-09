class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  url "https://github.com/tmewett/BrogueCE/archive/refs/tags/v1.13.tar.gz"
  sha256 "4c63e91639902d58565ab3c2852d89a4206cdd60200b585fa9d93d6a5881906c"
  license "AGPL-3.0-or-later"
  head "https://github.com/tmewett/BrogueCE.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "9315807bc80d4f5c5e0a6ba9a553204a86cc57654682f9a3a18636ec5b1161a8"
    sha256 arm64_ventura:  "e3b0a882c20bb197856f663d3d0e3ec41dfb77fa1dae82a36ae10bde05c6e842"
    sha256 arm64_monterey: "9f42024990d2827d78f86f0de71ceca8c6ce5e685ddf81b7b9b63d5f187311b7"
    sha256 sonoma:         "e90466c03e952b2df95e68006163b02cbe1e2f565fdcbff2ec3c9ca17233c798"
    sha256 ventura:        "d3a9a97ccf7c7810ea7a24ad32602896d819d3e4931505bff189424d4c87bd09"
    sha256 monterey:       "6d895d7e1a21e0fe9ef89b6d2bbdedcf4f2fde23cf07961735d2525e3e29fa42"
    sha256 x86_64_linux:   "f42bd9577f3d5b639e742c4bdcdb319032296ec4681293237353f945b49f641a"
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
    (bin/"brogue").write <<~EOS
      #!/bin/bash
      cd "#{var}/brogue" && exec "#{libexec}/brogue" "$@"
    EOS
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
    system "#{bin}/brogue", "--version"
  end
end
