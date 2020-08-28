class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.16.2/darcs-2.16.2.tar.gz"
  sha256 "161752851d910fb8d2168cb49b3b9bbe0571e0b622cd1d36d1ea174aa25255db"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "23d7f411f5a25d7f497464f84bf65219a832dae25c41dd23196f23d0e2343bce" => :catalina
    sha256 "390d52a8464c7cd66f7c0bdc34009bfdbb0542dbd67b2d2f54d2c56cb079a6b5" => :mojave
    sha256 "a7f172574b414fa8b0c8a6b2f1bbab54841240e1065a17d8419cf84df715f945" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

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
