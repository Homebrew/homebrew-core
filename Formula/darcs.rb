class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.14.5/darcs-2.14.5.tar.gz"
  sha256 "2f4e82f9e0a4748a63ef26753f04d960cc4afe4a0549fb9129b05c938b382dd2"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d33c5b3440f0bac7074dffcc2c8c29cd6baae8b9cae80c5487d22800fe09de1e" => :catalina
    sha256 "e1afecf373a7d537348eae1c1a6074086b0ba99e672aaa26789c8ed4d47f7a3d" => :mojave
    sha256 "04be680f0c1dfc0bb23c64bc80665ca858a1a15096de4c90748c65b27b975b61" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
