class DhallToml < Formula
  desc "Convert between Dhall and Toml"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-toml"
  url "https://hackage.haskell.org/package/dhall-toml-1.0.4/dhall-toml-1.0.4.tar.gz"
  sha256 "e2a71fe3a9939728b4829f32146ca949b3c5b3f61e1245486a9fd43ba86f32dc"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa04be536e7446641318c9d7ee241d0280b24061fda69b889a2988f48898e8b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b91f73c50c4c44ac7c5edef748f1c4f880a3ff0690ef64463f5dc04dfff85d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b221d5914aad68c046ae8f9f0fee29cd0e74ad55f4db5fd027f334daf71282e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "230e845fc7963e4f421247c6f7733af8a588782ad39232a446f6e1a65fccbb80"
    sha256 cellar: :any_skip_relocation, ventura:       "a118e324119fb58470cf49f4f898f0c3a603fc3975a11b2b3f60d66eeefdabe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0a91ba9614f2b28c79379fb9208a6aa25735985b7d79f84f75aeca830133e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7a0839d98769280508ea3d559828b88c1a78838f21bbceb64e179f6a7078f07"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "value = 1\n\n", pipe_output("#{bin}/dhall-to-toml", "{ value = 1 }", 0)
    assert_match "\n", pipe_output("#{bin}/dhall-to-toml", "{ value = None Natural }", 0)
  end
end
