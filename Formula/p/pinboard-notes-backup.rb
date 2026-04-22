class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/refs/tags/v1.0.7.1.tar.gz"
  sha256 "8539a62b8a4a718a716ecc4bf17150d7cef8a358b43fbca458de3540db3d5177"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "61ab93300efacf6806b22a12a68d41abb160245fbd468320985c72541e74c08a"
    sha256 cellar: :any,                 arm64_sequoia: "bd015512bf68cff2cce03386ecd6a33a60eda0db5aa5dce024c069f245a57f7b"
    sha256 cellar: :any,                 arm64_sonoma:  "7f2b54f27fc60f45bd2a54fe75c9c098ee16a2112ab7f323ee0cb618f0151636"
    sha256 cellar: :any,                 sonoma:        "87d95a1410a2d5f7332b9a86b4b822ef00bec53b26b571be9573308304b44238"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52b12aa0e866edb547e43aa8b3203a811cdab29f55b3860047a07f4f53bf9ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f27b387f833bca955fe44a98f07222cf8f31539067e5f6b538ad131df13c5a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

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
