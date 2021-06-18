class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.16.4/darcs-2.16.4.tar.gz"
  sha256 "e4166252bc403ffc2518edff48801796b8dab73fd9e0da1fcdda916b207fbe1d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2eb40b3fb513c55412df418660ad326eafab9f6403b85667e28b07048cc569f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e43e743a8d663a7383a0c335548a8b2b80fa00844e9cb77da3eb0db67bda93d1"
    sha256 cellar: :any_skip_relocation, catalina:      "74b07f9931b43dfcffd9b7fc2756ca13fc4d1b283a86d20fcf336a1f0cd19bb5"
    sha256 cellar: :any_skip_relocation, mojave:        "8c0805744fa94ec0e4467bc44de1fae811090d7987823485d57192cadea7bdd8"
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
