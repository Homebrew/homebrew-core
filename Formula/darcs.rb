class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.16.3/darcs-2.16.3.tar.gz"
  sha256 "8925ee87e2a7b4f3d87b3867dddf68344f879ba18486b156eaee4cf39b0dc1ad"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "123735089ca603892e15f1c4f0965b3eb52ad19528e032cdd90b47a723374baa" => :big_sur
    sha256 "918f313f3ed33f2efc56fde3187f0d3ee65239362cde6d625a488619fdedcf24" => :catalina
    sha256 "8a7c2e7696d23edfccd01c8672b363e9dd70302200df1110b4bec8f990570278" => :mojave
    sha256 "822edd3a9e96f82d76316d020ec17671dcede0a894878ec9f07bbcda466168dd" => :high_sierra
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
