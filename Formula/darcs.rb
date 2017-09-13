require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.12.5/darcs-2.12.5.tar.gz"
  sha256 "355b04c85c27bca43c8c380212988d9c1e9a984b0b593ceb2884de4295063553"

  bottle do
    cellar :any_skip_relocation
    sha256 "92a148502ee81e0be44a12531fa8b45331742cb28f28e83fb351b23c93a7a7b3" => :sierra
    sha256 "e11d1841f356e3f0ce47fc26951a81a23098d709fc726cbc786fa5451a002f14" => :el_capitan
    sha256 "1c0522297c9eb1c858888fa28434305d149e474329890137ff9827a3424cef82" => :yosemite
  end

  depends_on "ghc@8.0" => :build
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
