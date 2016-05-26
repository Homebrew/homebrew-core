require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.12.0/darcs-2.12.0.tar.gz"
  sha256 "17318d1b49ca4b1aa00a4bffc2ab30a448e7440ce1945eed9bf382d77582308d"

  bottle do
    cellar :any_skip_relocation
    sha256 "34cf772253eef5841ac056f3d71a352d81bc28c480ae5afe3411056799f1ce01" => :el_capitan
    sha256 "9f5f640b82e3f5d5188cfe3005115fc0ffe43d06bb1e3a3422612a377d0b59af" => :yosemite
    sha256 "3b8693859e7bbc66745141d9b3d1db01fdc9f2ef3399165bc6263d8a27bdfc08" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    # GHC 8 compat
    # Fixes the build error:
    #   checking whether to use -liconv...
    #   dist/dist-sandbox-296ea86f/setup/setup.hs:149:15-41: Irrefutable pattern
    #   failed for pattern Just lib
    # Reported 26 May 2016: http://bugs.darcs.net/issue2498
    (buildpath/"cabal.config").write("allow-newer: base\n")

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
