class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  url "https://github.com/tmewett/BrogueCE/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "dc562cf774f88b12b6aeebdac5a00e62e8598b3f84da2130a54a67a60c5debf2"
  license "AGPL-3.0-or-later"
  head "https://github.com/tmewett/BrogueCE.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43f07acb6933341084bf3d33ecc90b8c7a4a7ae1de69e9853cea13bb21fc6546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "065e96899c94736b5072b2f3aeb20a6f559f4d734730ff6bbc9bdd9d0f6eba3b"
    sha256 cellar: :any_skip_relocation, monterey:       "f342f2a96ca2b6a73b582d460993298b43b5c171199d6a7f42cf94c8b4c4d34b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba18162358c18f1f9bf064d49b3fcd7371f00f3aa3b6da129d169106b068aef7"
    sha256 cellar: :any_skip_relocation, catalina:       "2f5111318faeb8c710f6100706900f7c38e29f8cb90b06181ac5d95c784e8adf"
    sha256 cellar: :any_skip_relocation, mojave:         "c2171ad8115933295cde771bbe71e144d1c142c30224ada41aecbf70dcf3d239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d972aa4e6b4d0a1d80e28b904bba68d2fc938776edf9094a3d22c1af56644095"
  end

  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "ncurses"

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
