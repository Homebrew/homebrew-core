class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/refs/tags/v1.0.7.1.tar.gz"
  sha256 "8539a62b8a4a718a716ecc4bf17150d7cef8a358b43fbca458de3540db3d5177"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ecf5ebe63dd2afd072c841fdd93b48a83a4432ff21cf382eaf5d63513139768"
    sha256 cellar: :any,                 arm64_sequoia: "3adc5f0a65085d294884fb2e4d9f30c5680258993cf42109fed2e888b060ef30"
    sha256 cellar: :any,                 arm64_sonoma:  "0d68e9af81f782a5e5448b689c3dabc728b85271730b4dd9bbd54ecf3837f98c"
    sha256 cellar: :any,                 arm64_ventura: "adaebd25181a724dec9e17272ef0f2fcd98d0219fbd36653038dddcaf9b11f7b"
    sha256 cellar: :any,                 sonoma:        "ddccefd960008324daef76cd30ea92b6870d939c01c3c3e6caa15e01428f65fb"
    sha256 cellar: :any,                 ventura:       "4ddbd28f4fb04213eb995c1e4dde8acd9ca1d7f339155ffd3b818ad5100ca366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a286933d552029876b9c8957cf278b92eddc5c37abc8758ebc234fc3e053ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97a89973ad6d4fcb0ff7c5caa530764272ff4d73ed938cbb86acd0692cf36b08"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
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
