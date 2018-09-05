require "language/haskell"

class PinboardNotesBackup < Formula
  include Language::Haskell::Cabal

  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.3.tar.gz"
  sha256 "bc3ab1a8a3d92fcbda86dd8b4756b035be89e1e5b50bdd61f998b67c89243ae3"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a660948396cd9c35a0766c36257d25d537b7b6fca2b9661eb0360cd41c4f9a5f" => :mojave
    sha256 "1138cbd05fc88464afb783d8509336fb8bb82495700b34199d5c16dee1cbac41" => :high_sierra
    sha256 "77d4f8e3de1887bbae724aaaf2b72b7399adb8435153a192b7f39cabb8846c54" => :sierra
    sha256 "357931ecd198a6fad58d6a9cf3d8543b1dbc3a2fd0ec60e1887725791a2e6c6b" => :el_capitan
  end

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
