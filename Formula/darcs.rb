require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.14.2/darcs-2.14.2.tar.gz"
  sha256 "65d160a43874960dcba114c0b74d9c7b25d098486f515655502f42ff0c22a27e"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3d4489af9110556734688907ed7406fa91cf0d5b9b3dbe599d9cb8ab6372b33" => :mojave
    sha256 "e75f1d7feafae59ce8c0a46fec2ce5aee8e8ecf42344c4a9013a73f8b58cef69" => :high_sierra
    sha256 "6401d84ddea52cf6c7eda401a84672136eb8b880cfc531aba95a1d43bdb6dfef" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
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
