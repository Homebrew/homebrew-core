class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.32/dhall-bash-1.0.32.tar.gz"
  sha256 "3076073911f9ed917f74cec051e58e450a30c370bf0869599088e06567969778"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0debc7971a4817abd999054b714076d7ab0b76daac535c6e03093d945590714a" => :catalina
    sha256 "0339eda0413dbb5b3e2ba02474a0c45e3caedb8dba9bb052572de610fc8b3061" => :mojave
    sha256 "98ae1f84c7e785e92e82f766717579c3a2a0ff13a5b73f929e71d35fcfb74444" => :high_sierra
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
