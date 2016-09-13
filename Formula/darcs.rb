require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.12.3/darcs-2.12.3.tar.gz"
  sha256 "68ed535dce4bd2d8349ba04258bb56df7d47853dac9d3365fc0325a86db1cde5"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1b35b885507280caf1153c63c0333b414e63346a582c8dfc65f2f6047cb3e20" => :el_capitan
    sha256 "43c95d7ecc4fb0e8535bfcf3af6b41eaa9b228364a3062013c0b1d52557afd0e" => :yosemite
    sha256 "0805ccd89e7978ae518a8fd72d09b63d3ba466bf611618bcd1c5bea137281d64" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    install_cabal_package
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
