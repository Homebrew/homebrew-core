class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/refs/tags/v1.0.7.1.tar.gz"
  sha256 "8539a62b8a4a718a716ecc4bf17150d7cef8a358b43fbca458de3540db3d5177"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "9d81ad2cf860dcbbe903d303a5ab7aea6e9bedf73baa748355cb6feb8785d307"
    sha256 cellar: :any, arm64_sequoia: "317cb613612a6d18c8ed4fe8bc4b7947179455d647d3988a41c1cb2f1f7e214d"
    sha256 cellar: :any, arm64_sonoma:  "f913b55543f506bada705e43550504c5fa8643d4e1d5f1aeef34e71bb3da923d"
    sha256 cellar: :any, sonoma:        "d7483dba1f7ad5f27174a39f91f85c06004ed5dc938fdc555ff968f5f951f71f"
    sha256 cellar: :any, arm64_linux:   "403d32f5dd143781fd39b11100d24b9b2dd772ac3bebf8ee259cf53539a32a5c"
    sha256 cellar: :any, x86_64_linux:  "2a5fca050ae989d10198ecaa79bb19d8624b52b7f902bbe1e1a73bc85f3e1785"
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
