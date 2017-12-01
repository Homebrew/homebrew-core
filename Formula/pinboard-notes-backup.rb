require "language/haskell"

class PinboardNotesBackup < Formula
  include Language::Haskell::Cabal

  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.3.tar.gz"
  sha256 "bc3ab1a8a3d92fcbda86dd8b4756b035be89e1e5b50bdd61f998b67c89243ae3"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  # A real test would require hard-coding someone's Pinboard API key here
  test do
    assert_match "TOKEN", shell_output("#{bin}/pnbackup Notes.sqlite 2>&1", 1)
    output = shell_output("#{bin}/pnbackup -t token Notes.sqlite 2>&1", 1)
    assert_match "statusCode = 500", output
  end
end
