class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "7c296c1d42ed3c059d72e303f5a35d0d575d7bb2bb0a28a5fae1f36bf151ac77"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54901aecd1ce3df91e8332f9e7c711156422dfdb2b0d91c08facf995f5fd4b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6db312954370b05b042448cf967fbff5c966fb2c4e6d68ad17883d2890ac29f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca53a06af4eb68273975f8c20d784a12eca64c9df6d4b96377bfff77ac273cb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ed4c5804e37c9be4f243675456e023183d737b94a8c310a24b71bb382431037"
    sha256 cellar: :any_skip_relocation, ventura:       "203ff0729e4baad033699c6c24cc1f2ec46612aa372ffbb56ac1bb18c6ce62e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25b7c77c34baa4f08c806812392c94182ef7b9360a4bf0498dfee76796eb61b5"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

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
