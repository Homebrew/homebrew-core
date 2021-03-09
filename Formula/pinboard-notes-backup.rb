class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.5.2.tar.gz"
  sha256 "e326fb407b1127ce3bed80930477cbeef4aac05ba3c44ddac117aef9016f5d7f"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "b14513ed43c8bf9176111e913154b6c9351da0fd40b0d2b6889237f2cb2e7f1e"
    sha256 cellar: :any_skip_relocation, catalina: "91b6d42a2b460055184537d40b745babcfd6b9eac2f9bbe4c0a02b2efb6d3a17"
    sha256 cellar: :any_skip_relocation, mojave:   "55ec30fc54c829a928f7b5878c5288bc4a800a41e42d5ef3676a3c44c6ef343e"
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
