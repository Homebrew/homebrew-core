require "language/haskell"

class PinboardNotesBackup < Formula
  include Language::Haskell::Cabal

  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.4.tar.gz"
  sha256 "f402418a005a8c7e4ba980ded37ed35530edd896a0f57a8c50cc39add7432704"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "546bb1aa255c67331b1436035960bb49cfcd0d4a093050e4670386d8e4d9d330" => :mojave
    sha256 "07b024d0b1c50325561ca382b6f90ee5aab261093cbc92498862608a6a11cc61" => :high_sierra
    sha256 "d07095e46fd0354044caf2c7125f1d307fd728c97ae5eb32309d97cbb2cf4d30" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build

  def install
    install_cabal_package
    system "./make_man_page"
    man1.install "pnbackup.1"
  end

  # A real test would require hard-coding someone's Pinboard API key here
  test do
    assert_match "TOKEN", shell_output("#{bin}/pnbackup Notes.sqlite 2>&1", 1)
    output = shell_output("#{bin}/pnbackup -t token Notes.sqlite 2>&1", 1)
    assert_match "HTTP 500 response", output
  end
end
