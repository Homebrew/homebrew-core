class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.16.5/darcs-2.16.5.tar.gz"
  sha256 "d63c6cd236e31e812e8ad84433d27059387606269fbd953f4c349c3cb3aa242b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d03a37a9b8cb29eb9cd4ff21b169c63db57c681edb4761ea3004bdc15fa17f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad19b2f85d71c0fdfb32ee9e5d758a7491877dd99e854ec7759acdaf59f90ebe"
    sha256 cellar: :any_skip_relocation, monterey:       "160b91bf58a6d87b60e85e62ad2f6124c0d952f921389d82f04114788bd6c0aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "bedb352218c8ae7e6c209f3297dfd25df8bfbbbf2e99559c964133e81989209c"
    sha256 cellar: :any_skip_relocation, catalina:       "2db034fcb43671e797cf5d6ea83359fabce3de8fd3653c6dfaef6d356b27ea1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3f9ad7d74ba60c4f75fea414168304c2bd7d3dbe9c6ee0ca249a7d10703740"
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
