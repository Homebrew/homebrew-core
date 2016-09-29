require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.12.4/darcs-2.12.4.tar.gz"
  sha256 "48e836a482bd2fcfe0be499fe4f255925ce50bdcf5ce8023bb9aa359288fdc49"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d33f7b5cec27310161b94685b071772e71bead0baf2a5c2d9512d8a2778a296" => :sierra
    sha256 "e4099cc0dba32425ce9298ffc534e64cab6f5cf1323a2b569355e9435492a10a" => :el_capitan
    sha256 "ab8333149f6eb4853696bbfea1b38e30e972ab676b54c3b416990be6fb74c917" => :yosemite
    sha256 "4f3d6df794f5cef9c817afe07413951fef3f09a4624381b3a4509ee8723aee17" => :mavericks
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
