class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.42.3/dhall-1.42.3.tar.gz"
  sha256 "cbb5612d9c55b9b3fa07ab73b72e6445875a6f53283f29979f164a9b3b067a00"
  license "BSD-3-Clause"

  livecheck do
    url "https://hackage-content.haskell.org/package/dhall/docs/"
    strategy :header_match
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "4dc1b8489b6a23b7c9ead22e5f14a2c0cd352006a6a98004d0df11fb066518bc"
    sha256 cellar: :any, arm64_sequoia: "4efcb45660caf4d565e55e92b72bf91b1f6fa09c7237e09becfb718e3ebdafbd"
    sha256 cellar: :any, arm64_sonoma:  "d050e8f0751a9c6f323322cd295816c3d0c60da76869009004a35d2aef6e4a96"
    sha256 cellar: :any, sonoma:        "7586497823854900604eda21ebe86865b311876cd6ef39abfe53d51dbf7b91a3"
    sha256 cellar: :any, arm64_linux:   "17200bbf9bac101bff87e218fa1ee9a74ca2a13d87df1ef06c7a4c788bbc32f1"
    sha256 cellar: :any, x86_64_linux:  "bf76e887106f959e317c36a262b1031ef352c63c54a9b3224a6ed39d5fb5fe93"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
    man1.install "man/dhall.1"
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "(x : Natural) -> Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
