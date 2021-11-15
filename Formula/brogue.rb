class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  # The OS X version doesn't contain a Makefile, so we
  # need to download the Linux version.  This is the
  # file "brogue-1.7.5-linux-amd64.tbz2" inside their
  # official google drive they distribute source from:
  url "https://drive.google.com/u/0/uc?id=1ED_2nPubP-P0e_PHKYVzZF42M1Y9pUb4&export=download"
  version "1.7.5"
  sha256 "a74ff18139564c597d047cfb167f74ab1963dd8608b6fb2e034e7635d6170444"

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
