class DhallToml < Formula
  desc "Convert between Dhall and Toml"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-toml"
  url "https://hackage.haskell.org/package/dhall-toml-1.0.4/dhall-toml-1.0.4.tar.gz"
  sha256 "e2a71fe3a9939728b4829f32146ca949b3c5b3f61e1245486a9fd43ba86f32dc"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d202ffbdfbf211631563eca1903d4d0a5042a1c121a0846159b5f181b9381e94"
    sha256 cellar: :any,                 arm64_sequoia: "f60b0a53a5b7aea1eb8971c09d147d36b6eb6ac790a58e40feb7d1da7294f425"
    sha256 cellar: :any,                 arm64_sonoma:  "63f45b97bae8d4a1bf2a8c35d76ade363a6438c10f6dddbb7af07ced0e8b5607"
    sha256 cellar: :any,                 arm64_ventura: "bfe459be3cde24c50eaa7cb0f40902c52ce55c96071c70b51353a33ef2a65e22"
    sha256 cellar: :any,                 sonoma:        "79f2377d29cbb9b166c4841933e87ac9d51ee7293be86ff64c7d1ef4dfa240f1"
    sha256 cellar: :any,                 ventura:       "d73c097010f35b7556b0111c4237cb2f646c3563932b5a188fae2e7de826f093"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4c783644bfdf7d1510ed0f7599268228e9fa70b72dde0e1491d622234e3fb87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1954c0b395d67fea8d74fdec8b544aa385e708e6063b7616e156dabbaaed9ce"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "value = 1\n\n", pipe_output("#{bin}/dhall-to-toml", "{ value = 1 }", 0)
    assert_match "\n", pipe_output("#{bin}/dhall-to-toml", "{ value = None Natural }", 0)
  end
end
