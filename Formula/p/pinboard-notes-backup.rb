class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/refs/tags/v1.0.7.2.tar.gz"
  sha256 "c3499d02171fadbb6104bd6559d3ca95a09217c78d056fe08f45be5dd50755ad"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6bfac23b984fdfd44d10901e9d3e104a5ea5f2ebdf6b9570d2219b29713bb3d2"
    sha256 cellar: :any, arm64_tahoe:       "bd2c56e222b2cb807951af276d1ac11be1606fed2e8eb72bcb4bfbb63820a761"
    sha256 cellar: :any, arm64_sequoia:     "9af682e38cd19f166b21ee9bb3c3db0896ded9c895a732c3fc412c3fe28e46b2"
    sha256 cellar: :any, arm64_linux:       "c4056dc3fc0e69137909a9d1dde7ebdcfcf2bf2c261358191319e8c662e201c9"
    sha256 cellar: :any, x86_64_linux:      "af91351f430a18eedceb660cd872e32ed53829ef4a3bd38a2fdeeb2eb8e902b3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
