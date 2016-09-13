require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.12.3/darcs-2.12.3.tar.gz"
  sha256 "68ed535dce4bd2d8349ba04258bb56df7d47853dac9d3365fc0325a86db1cde5"

  bottle do
    cellar :any_skip_relocation
    sha256 "81ca8d26e8fc3da1c38974f959caf1f869d30f10c32972c53ffa87cf8f68ecc9" => :el_capitan
    sha256 "44e258f918e16f65b6670c0f350b8efd933533bfb6c6669cb5a7a22b0d354f19" => :yosemite
    sha256 "75efc3d25ecb688b9ded8cecc712ac2d85cd2dfef0bb98f99425bb8262d88c6f" => :mavericks
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
