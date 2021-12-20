class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.39/dhall-bash-1.0.39.tar.gz"
  sha256 "68ce22ada11dcd7d92268b79363bd51c835aecd1f44e8b93ce1e448d5be1c02f"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6caad7ccfc94810c715b13339c454c19108d0d1b3f5a8d81583b570e2a947bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05f1e423404871f9f1e7e4d70b8a0cb5624459192576baa759dba81f283e7ca7"
    sha256 cellar: :any_skip_relocation, monterey:       "45e68da3431c8afe44a0aab27ec6cc2e8df5bd3b900fb216662d70028bb6cce5"
    sha256 cellar: :any_skip_relocation, big_sur:        "422da387734aade14504d23209baef56153fa79f7f0818a3b43aaf4ff36cef6c"
    sha256 cellar: :any_skip_relocation, catalina:       "d10895044abb7447837100eb89220c4b1de1a95002e551900498fe68aca5da64"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
