class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.5.2.tar.gz"
  sha256 "e326fb407b1127ce3bed80930477cbeef4aac05ba3c44ddac117aef9016f5d7f"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "0d2b1458a9bbcf492307d046f443411fda268e5f28b458b54350ad0b4c739e7a"
    sha256 cellar: :any_skip_relocation, catalina: "4de03f843b5371acfddd78a0561db3b3e7070cb865206f2044dca880ba1142e9"
    sha256 cellar: :any_skip_relocation, mojave:   "cbc7eb55b663ed4c34ab3d70f996cb3bfb77e2162c5a391d55c16e1251107a2c"
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
