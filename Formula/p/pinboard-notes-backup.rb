class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "bd26a1cd7ec4e0a83cd06c1234420ac9262d39c926a42820958502967005f63c"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db4446ba2acc253e4311931498466fcbb817a7d4f0a40586c57a398199e28272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "269d2c336cc103226d08d1347b641d2ed03a98b41468e14b97c619b1ec0182b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bbaa3f7e02e6359afb9b42066fc2e975c31f2ed2cfc3cfb4e5cfdf3649da43c"
    sha256 cellar: :any_skip_relocation, sonoma:        "878786cea9c65cb998b04c9986bd0ef267203e57bac2c0c413b914a79c2b3215"
    sha256 cellar: :any_skip_relocation, ventura:       "1e1d6084bee6d414a922988d46a79f8f8d34d20fb983d151049889ded6a47154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ea494e407702d438d26039b44082e145d14fbc04d38fe5fe66062b08fdcb06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c73c136aeeb04488e72260d28b820e81791f13cdcf7da540f0e80352a4a3365d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    # Workaround to build with GHC 9.12
    args = [
      "--allow-newer=http-api-data:base", # https://github.com/fizruk/http-api-data/pull/146
      "--allow-newer=req:template-haskell", # https://github.com/mrkkrp/req/pull/182
    ]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
    man1.install "man/pnbackup.1"
  end

  # A real test would require hard-coding someone's Pinboard API key here
  test do
    assert_match "TOKEN", shell_output("#{bin}/pnbackup Notes.sqlite 2>&1", 1)
    output = shell_output("#{bin}/pnbackup -t token Notes.sqlite 2>&1", 1)
    assert_match "HTTP 500 response", output
  end
end
