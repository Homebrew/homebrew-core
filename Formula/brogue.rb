class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  url "https://github.com/tmewett/BrogueCE/archive/refs/tags/v1.12.tar.gz"
  sha256 "aeed3f6ca0f4e352137b0196e9dddbdce542a9e99dda9effd915e018923cd428"
  license "AGPL-3.0-or-later"
  head "https://github.com/tmewett/BrogueCE.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "b3fb81412edaad2c3447f2500430162487f422c8e6e48acf887fb029a8aa40f2"
    sha256 arm64_monterey: "f545e3d7758f956956599d3cb01dbfd230349ab70b4751b9398973e26dbeec52"
    sha256 arm64_big_sur:  "886aa3d64dd77d365d4c8ce311ab0a0194c5f3c876c51887b626d148307b6a14"
    sha256 ventura:        "31081da4bd41c4471fc2579095688435b1011a5def3c466ac722bf3b636906fa"
    sha256 monterey:       "cccb038be8fffad521143a7dd87e9b94a5aacbce8462e6b1317a8f1ff8714463"
    sha256 big_sur:        "4f8184e978f64e2b3c3dddb5af5721fe1ecb3431f69a1c85e3673eb024733d43"
    sha256 x86_64_linux:   "83b284e5c9b8d58756ac33e743d56b9bac827cfab5e965070a24dc5b6b849e1d"
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
