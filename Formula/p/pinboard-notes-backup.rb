class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/refs/tags/v1.0.5.7.tar.gz"
  sha256 "12940372b976bbc9491e20810992396426f3ee482416a42e6379bdad9999a07c"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63e685a5471c77c535f67b05195429f4d71c3e9f655b0d3faf591025c7a1f36f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d375d8d2a1c76e2ac6dc0f93656182cad288b58c3c3457922955df7ff3fbb87b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b570d147f98d42f9fc47429fdd14bba0f59f7038d9922429b3ef911fd5b38f7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bb2a015045e1d6d0870f523473379af184034a878754a55b27452896db4893e"
    sha256 cellar: :any_skip_relocation, ventura:        "e793489b6fd7c1658683dd16ebc56d2e266be7cdffcfb997f49ba76ac4012dad"
    sha256 cellar: :any_skip_relocation, monterey:       "20dcaeaadae53a452675a64a3f435537d54d813108da2e3d216e79fb7be42908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19365a6c0ca7c4d6a56c8bbfd591346ab77c23b89c7e4a2aec77ddc9eba57fe7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build

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
