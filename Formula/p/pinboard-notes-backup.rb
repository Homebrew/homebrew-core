class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.5.6.tar.gz"
  sha256 "0b544d5e3dfd0ebf029b50fcb405045f601dac1f103fbd95f2b24b5aefd4ef40"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a23126069b6eb37ec5fa9cdfc4e90fdec0607b7e5b663f369ade70f4622edd34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0179793fea1c674a55303c6fbd09a0eb18479f69ea4913d899051998d431015"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c14f48435e8582dd61b1c90c499a2532f288af4ab8676c10341348dd4c80c4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6a4583d4eec71832fb5231d5a461ab4a6a9f46824965f4f4d70971d6dc2800a"
    sha256 cellar: :any_skip_relocation, ventura:        "d7d134ba104152960322db03077c2747145f9eed0767365654ddf0dd0e1ce747"
    sha256 cellar: :any_skip_relocation, monterey:       "961d9679a44ca529b677128731d8c08b975bf4c4d24a331249519e408f5a5059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4207355c1a379695a0eac57910fc29b23eed8fe6f296c3068044ef327b488276"
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
