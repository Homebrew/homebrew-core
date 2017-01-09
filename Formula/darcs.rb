require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.12.4/darcs-2.12.4.tar.gz"
  sha256 "48e836a482bd2fcfe0be499fe4f255925ce50bdcf5ce8023bb9aa359288fdc49"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "063b9b740555c334a36cb58afb9be68bad978628645ea802988d4dfc01ef222a" => :sierra
    sha256 "0d422424a2f04fdf5cd15d6923ea27917dad72f9612251c2ba2f21a05ce05f8b" => :el_capitan
    sha256 "1ed9f35fdf0d891176cb54688da87ebe189164126e7633a66e6723d13b48e2a9" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    # Upstream issue "darcs.cabal needs directory 1.3 compatibility"
    # Reported 9 Jan 2017 http://bugs.darcs.net/issue2520
    inreplace "darcs.cabal", "directory    >= 1.2.0.1 && < 1.3.0.0,",
                             "directory    >= 1.2.0.1 && < 1.4.0.0,"
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
