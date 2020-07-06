class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.30/dhall-bash-1.0.30.tar.gz"
  sha256 "384476a4fb3bf5cca70104f093faef580764e56fc9998a56eeb9fe8918ca5de4"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e9aa1c41339f0b814092a8c79e9e64ddc01d1a3e82987f70c9ea6fd846aecbd" => :catalina
    sha256 "bccd32bf6ec6f821af0cecedd3d8e9f68b2526c54f00c93c38102fa76c8e7c9d" => :mojave
    sha256 "07250c7114969008c76c554055f08fe9869673deab11926b5010a2d4e116ba3c" => :high_sierra
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
