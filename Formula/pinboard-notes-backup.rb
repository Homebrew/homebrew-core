class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.5.4.tar.gz"
  sha256 "c2a239f8f5d7acba04c8a5bdf6e0f337e547f99c29d37db638d915712b97505d"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3069c8f2bf3d19e00854023d614cbfaa54124714bc24f19add7342fddadbc7fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "872d668ef3797167027e12761a3d7f75624c1fa0f2d2fd319e003647f6d67d0e"
    sha256 cellar: :any_skip_relocation, monterey:       "014147bd4fab3f85d1d01efa02132303dbe6240ef67c7a71c1fe4f4595ea7d0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b383069c859d37cc356106c445768f3996f1eac4a83e20d57d9800a0c4328485"
    sha256 cellar: :any_skip_relocation, catalina:       "8f86319b5bd957198edc1a19cf7af1a11fba9ee5ef950f8f8bd8b8f56af0d37c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183578ddb3979e5736e4d317eb393c4b967f63421b30eb8a5c8403fafc398624"
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
