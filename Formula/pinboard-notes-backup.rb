class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.5.tar.gz"
  sha256 "eb4409edd52745cac16a68faf51f6a86178db1432b3b848e6fb195fd7528e7da"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e904a9c00e26580d3f45716bb16987c4174850f85d5ee441073c1c1ee5b91d24" => :mojave
    sha256 "8815547595a8642a26183a7701bb13d9a60068fd5b7aa9d34506f584c3158580" => :high_sierra
    sha256 "b5673dd192867c0a38dfc9443d1272b42bc303d3561949ce3157ea7300e2aeb6" => :sierra
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
