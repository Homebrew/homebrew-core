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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8d1cada694c3dfd625aeb86fa339784b3fcc62bf88b561cc845bfb74f36d6f33"
    sha256 cellar: :any,                 arm64_sequoia: "3b7a347308cfa4b651651415e637778f07ae2b5f7a0d5d58d738e194d2c45500"
    sha256 cellar: :any,                 arm64_sonoma:  "7e537b533bd61f3b7eaa8b0a9f21e934f887f2fbb2a7610e76a12ec25d5d795a"
    sha256 cellar: :any,                 sonoma:        "1684b9448091971b87dc6e1764028f94f891a874056ebc72b24efdeac50eac01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae7bc8a7b099ffe0baf3d2c64be38d16b59eb193b9dde5dc593d4821a23d8229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4988d54246a5d4db6d2419c51ff3ff53f48be865a35223d86a919a544fcb953"
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
