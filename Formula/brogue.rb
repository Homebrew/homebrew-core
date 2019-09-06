class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  # The OS X version doesn't contain a Makefile, so we
  # need to download the Linux version
  url "https://sites.google.com/site/broguegame/brogue-1.7.5-linux-amd64.tbz2"
  version "1.7.5"
  sha256 "a74ff18139564c597d047cfb167f74ab1963dd8608b6fb2e034e7635d6170444"

  bottle do
    cellar :any_skip_relocation
    sha256 "62d88540558c2f014403686898cf68d9a44c62e0095e285e77958b66e5c1ff3a" => :mojave
    sha256 "864ae48cf80e2f1f3dc2a31a2ea4811177906eda30b11d12d5e3018ca4f1f3b8" => :high_sierra
    sha256 "b5f6a25670f2eeb737bcde972b78801892971e2af4e3f7df1bbaa237eb4db50f" => :sierra
  end

  uses_from_macos "ncurses"

  # put the highscores file in HOMEBREW_PREFIX/var/brogue/ instead of a
  # version-dependent location.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c999df7dff/brogue/1.7.4.patch"
    sha256 "ac5f86930a0190146ca35856266e8e8af06ac925bc8ae4c73c202352f258669c"
  end

  def install
    (var/"brogue").mkpath

    doc.install "Readme.rtf" => "README.rtf"
    doc.install "agpl.txt" => "COPYING"

    system "make", "clean", "curses"

    # The files are installed in libexec
    # and the provided `brogue` shell script,
    # which is just a convenient way to launch the game,
    # is placed in the `bin` directory.
    inreplace "brogue", %r{`dirname \$0`/bin$}, libexec
    bin.install "brogue"
    libexec.install "bin/brogue", "bin/keymap"
  end

  def caveats; <<~EOS
    If you are upgrading from 1.7.2, you need to copy your highscores file:
        cp #{HOMEBREW_PREFIX}/Cellar/#{name}/1.7.2/BrogueHighScores.txt #{var}/brogue/
  EOS
  end

  test do
    system "#{bin}/brogue", "--version"
  end
end
