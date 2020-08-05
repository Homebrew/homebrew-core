class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.14.4/darcs-2.14.4.tar.gz"
  sha256 "e7721151000857a6ab53d7ee82a3d3e8e741b19c2cff0da2a2c9dc1285026762"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccab83cfccbad379fd029b56b83cd79ad3587b42176e6d1e412bb08059f9a297" => :catalina
    sha256 "b3febd7322260478d4043baad71f56322e2a14283e5343a7bc1b8d7ab366f266" => :mojave
    sha256 "5b578c424e77b5d9174beea3c3ac25f4219002ffd0707506aba815e6ec7fd1eb" => :high_sierra
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
