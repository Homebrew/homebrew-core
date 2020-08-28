class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.32/dhall-bash-1.0.32.tar.gz"
  sha256 "3076073911f9ed917f74cec051e58e450a30c370bf0869599088e06567969778"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6cf2bdf4f89a1f415dd7a101075bd3d15e824a2a06f237575e5a922b86770ac4" => :catalina
    sha256 "2fda14de57beb8ae22c9c3b8fa233bf489c2292602fe609961b6928f2df3afc0" => :mojave
    sha256 "b0a6064127d75cfa65b532954ca8ac041db9df1ea2e2df60427d027b52fb797a" => :high_sierra
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
