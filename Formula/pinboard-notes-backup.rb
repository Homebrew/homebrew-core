require "language/haskell"

class PinboardNotesBackup < Formula
  include Language::Haskell::Cabal

  desc "Efficiently back up the notes you’ve saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.3.tar.gz"
  sha256 "bc3ab1a8a3d92fcbda86dd8b4756b035be89e1e5b50bdd61f998b67c89243ae3"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  depends_on "ghc@8.0" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  # A real test would require hard-coding someone's Pinboard API key here,
  # which would be a bad idea. Instead, as a simple functional test, we call
  # the executable without the required --token parameter and make sure that
  # the exit code is 1.
  test do
    require "open3"
    Open3.popen3("#{bin}/pnbackup", "Notes.sqlite") do |stdin, _, _, wait_thr|
      stdin.close
      assert_equal wait_thr.value.exitstatus, 1
    end
  end
end
