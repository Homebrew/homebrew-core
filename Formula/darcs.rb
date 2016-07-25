require "language/haskell"

class Darcs < Formula
  include Language::Haskell::Cabal

  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.12.0/darcs-2.12.0.tar.gz"
  sha256 "17318d1b49ca4b1aa00a4bffc2ab30a448e7440ce1945eed9bf382d77582308d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "8d744eaa804cf2e9ce405fcd3ab29db59ef9f6286556cc6220fcd63c0e3182a3" => :el_capitan
    sha256 "d160df6cfb19fcced554784555e317689591156a1b5298cab20d03bb6f378f6e" => :yosemite
    sha256 "c37bcbefd62e023c1c9f5b07c91c4f34a3ad346945bdcc5b758b1eeea4cefeec" => :mavericks
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
