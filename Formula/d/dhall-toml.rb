class DhallToml < Formula
  desc "Convert between Dhall and Toml"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-toml"
  url "https://hackage.haskell.org/package/dhall-toml-1.0.4/dhall-toml-1.0.4.tar.gz"
  sha256 "e2a71fe3a9939728b4829f32146ca949b3c5b3f61e1245486a9fd43ba86f32dc"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "3d83e52092e335ddba928d06ae826157f26f8179ab7db6b757b4c298bf1faf60"
    sha256 cellar: :any,                 arm64_sequoia: "996c152df3dfc9a03b591e6e73125344fb7828a98c9b735d1c8ee3b8f3e1f0d5"
    sha256 cellar: :any,                 arm64_sonoma:  "6338c0b88b6f2eaa8a42246a7ab9c5fa6e3c265578f0fcce47a652f89895ecda"
    sha256 cellar: :any,                 sonoma:        "c67986762a7976ae8707fb802f8350871b8d3a182b81b04c4fc92222c7cc9f9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40e8c1b7e7f0470c7faf90f1d53ba7372a8b581547c1259d1d8363f852318aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb108a5e80145086584ae1367ee0eebe475ddc8a89419415e2e1d7536c7624d"
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
  end

  test do
    assert_match "value = 1\n\n", pipe_output("#{bin}/dhall-to-toml", "{ value = 1 }", 0)
    assert_match "\n", pipe_output("#{bin}/dhall-to-toml", "{ value = None Natural }", 0)
  end
end
