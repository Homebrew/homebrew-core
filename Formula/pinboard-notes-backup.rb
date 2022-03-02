class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.5.4.tar.gz"
  sha256 "c2a239f8f5d7acba04c8a5bdf6e0f337e547f99c29d37db638d915712b97505d"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "57a89dec64c38b1742914b5ff0cb7e0a1555715644b465ecae8b2c67c7580ec2"
    sha256 cellar: :any_skip_relocation, catalina:     "a1c7eb9a928d9461b66bcd43af6dbaa276d7cd730706e2b57833f70c503fdaaa"
    sha256 cellar: :any_skip_relocation, mojave:       "d0e2d4abf24f35b65aa3f5454febc68444f33fcba3d0c01ce33a5f571ef4477e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3ed421ceef39a006065676d8b8f2c3ba553e0986ab7187a7956f6504389904b2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

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
