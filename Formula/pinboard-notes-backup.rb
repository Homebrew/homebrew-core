require "language/haskell"

class PinboardNotesBackup < Formula
  include Language::Haskell::Cabal

  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.4.1.tar.gz"
  sha256 "c21d87f19bba59bb51ff7f7715a33a4a33ced20971f4881fd371ab3070a4b106"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e904a9c00e26580d3f45716bb16987c4174850f85d5ee441073c1c1ee5b91d24" => :mojave
    sha256 "8815547595a8642a26183a7701bb13d9a60068fd5b7aa9d34506f584c3158580" => :high_sierra
    sha256 "b5673dd192867c0a38dfc9443d1272b42bc303d3561949ce3157ea7300e2aeb6" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
    man1.install "man/pnbackup.1"
  end

  # A real test would require hard-coding someone's Pinboard API key here
  test do
    assert_match "TOKEN", shell_output("#{bin}/pnbackup Notes.sqlite 2>&1", 1)
    output = shell_output("#{bin}/pnbackup -t token Notes.sqlite 2>&1", 1)
    assert_match "HTTP 500 response", output
  end
end
