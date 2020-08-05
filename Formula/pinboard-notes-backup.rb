class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.5.tar.gz"
  sha256 "eb4409edd52745cac16a68faf51f6a86178db1432b3b848e6fb195fd7528e7da"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1735309c67f5ff12f212c8f780fe0cfb3d0409c53ce9376ee265597ceb517693" => :catalina
    sha256 "244865afa3cd3d89f059dd4e6a162de07ce8d404c9ea2c05dc92ef17869c75e8" => :mojave
    sha256 "cddc7122a3aa1aec17c18d2e50f471a154db42006684b7ba8d5fb4b2cfd5842f" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "man/pnbackup.1"
  end

  # A real test would require hard-coding someone's Pinboard API key here
  test do
    assert_match "TOKEN", shell_output("#{bin}/pnbackup Notes.sqlite 2>&1", 1)
    output = shell_output("#{bin}/pnbackup -t token Notes.sqlite 2>&1", 1)
    assert_match "HTTP 500 response", output
  end
end
