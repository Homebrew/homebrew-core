class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.5.6.tar.gz"
  sha256 "0b544d5e3dfd0ebf029b50fcb405045f601dac1f103fbd95f2b24b5aefd4ef40"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a25aa11fe52d764d56bbedbece7d68c8650b5dc21a2bba87c34b6cea1b032e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44a95be5ba2c82644c18c048756fe4223dd61f2ba7fd010e0c895cbe78b0585a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a668842564ed2394a77076e8c3e8b4efe8b9b5032e2a3316f8ff3a741acc480c"
    sha256 cellar: :any_skip_relocation, ventura:        "e3b01674e194bf24426b5414f0468ad94b2286862a02338a7f9c26767cf9f2fa"
    sha256 cellar: :any_skip_relocation, monterey:       "bb0049130131cd64c501093904ff99a6df2d2bc26e4c4c05aafbe840e28c9b27"
    sha256 cellar: :any_skip_relocation, big_sur:        "01a6a006a5df7ec5ad09606c18a80ae9df4b4551035c35c7777ef6220e691445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d27dbcd35071c388a067a7b15bf279f334b0c188d121afbf50cab84c261e5ca"
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
