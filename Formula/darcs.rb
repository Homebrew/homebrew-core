require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.14.0/darcs-2.14.0.tar.gz"
  sha256 "19fa0882a1485f03ab0552d6f01d538c2b286c4a38a1fe502e9cf2a78f782803"

  bottle do
    cellar :any_skip_relocation
    sha256 "a18baed73cb1b77ef9cbaf499ff313d9b9b347a04d17b82fa6c7bce83ff27957" => :high_sierra
    sha256 "ab1aafc30e70ffcfd7a397ffea6b5b668aed5ed1572eaba135ee1106a560201c" => :sierra
    sha256 "b7145e37e8e32034065ea7a4031810417ff6387e665ca3a6ea89638e7994b43f" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  def install
    # GHC 8.4.x compatibility; remove the extra arguments for darcs > 2.14.0
    install_cabal_package "--allow-newer=darcs:async",
                          "--constraint", "async < 2.3",
                          "--allow-newer=darcs:graphviz",
                          "--constraint", "graphviz < 2999.20.1"
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
