class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "https://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.18.2/darcs-2.18.2.tar.gz"
  sha256 "e665518a0a62eccb9e071243005e4b3f7e365186a1aa49d60779f6d35da13386"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e75f8af136a584f27bbf6e5b75c1097af89f4eb7a00c13ad492cdd141eeb5402"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e53c322d2661c0df69da06e67daa583af32d2e716dc5eaf90e0fd398c769e36b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbad85284672a6fbb6b8db9a01b1e02b39621cf8e7e7f85e0cc102e4747f4809"
    sha256 cellar: :any_skip_relocation, sonoma:         "7729042c6498914cadaddd5551470312a41d7c2318fe5c15b06aba165f5426d7"
    sha256 cellar: :any_skip_relocation, ventura:        "bb68f03394f84b7ad4a94368795bfcf52473265406793b0db8a08297fb78ecc1"
    sha256 cellar: :any_skip_relocation, monterey:       "adcc78dfa613a71c937a581219f31471b9b45a3f63321b4b5b14a2ebe189bdbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1560f58104a953cb055873bafc035ff828f32a7803286f439bc61e52267ddeb2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    mkdir "my_repo" do
      system bin/"darcs", "init"
      (Pathname.pwd/"foo").write "hello homebrew!"
      system bin/"darcs", "add", "foo"
      system bin/"darcs", "record", "-am", "add foo", "--author=homebrew"
    end
    system bin/"darcs", "get", "my_repo", "my_repo_clone"
    cd "my_repo_clone" do
      assert_match "hello homebrew!", (Pathname.pwd/"foo").read
    end
  end
end
