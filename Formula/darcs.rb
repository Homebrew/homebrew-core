require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.14.1/darcs-2.14.1.tar.gz"
  sha256 "61ddbc99acaf06df3a114437064e9241e0da467c23d1d3fb520a782eee32cd35"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a709960a2e92c4a1bc77bd1d14e98694a26bce78028c5dcb3c1456b86f1b449" => :mojave
    sha256 "6618314c01b2aeed0ad4d8f10f017f4ed24ebb4d8bb96d77b92a4be0f5a36dc6" => :high_sierra
    sha256 "b0063bb736e782887caa458a63899d66f84ebfeb4e950ad41b4ba27128ccf4fb" => :sierra
    sha256 "61148f3fb7580ada1e83a2f1219942237e7fec26c6161fecdd8aa533e8529f98" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
