class DhallToml < Formula
  desc "Convert between Dhall and Toml"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-toml"
  url "https://hackage.haskell.org/package/dhall-toml-1.0.4/dhall-toml-1.0.4.tar.gz"
  sha256 "e2a71fe3a9939728b4829f32146ca949b3c5b3f61e1245486a9fd43ba86f32dc"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "47f4e8cbcd85074cc4fc806d77280a0698768f252247b2d6238300cfd4ed8289"
    sha256 cellar: :any, arm64_sequoia: "c78a2cb703727122a513ec63dc164827260fc1b43d55b36abfedaf24840cb098"
    sha256 cellar: :any, arm64_sonoma:  "fea67b3c34c81ea0e9db66f2527bc10610fb60e2eb16e4ee0446a2913ed30a20"
    sha256 cellar: :any, sonoma:        "d9d3818dec3ff50798a8a96eb5aec30684b054b1f4a246d801c8f7f880cfb3e2"
    sha256 cellar: :any, arm64_linux:   "9c3dc1dc74998aef89783d3798d6465db609731af0cdf1703fa163962f8ab2da"
    sha256 cellar: :any, x86_64_linux:  "cb0a3329f50824fa61942f2368a0d2beaed20033534d423dd9c09e3299897f7e"
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
