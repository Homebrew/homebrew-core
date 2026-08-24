class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://ormolu-live.tweag.io"
  url "https://hackage.haskell.org/package/ormolu-0.9.0.0/ormolu-0.9.0.0.tar.gz"
  sha256 "212ee5ec17638f802a406122c8b839e3e6aa05d9b5886bfeb46cc90935f0bc6f"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a0d2968ad5d9a2144cc94351275ce28b9af5f6dff6517f14da77fe6ebdbf2251"
    sha256 cellar: :any, arm64_sequoia: "72c109afa8ebc7bc4556d4c71d5a3a2fd0e05636b7eae53239b2c747a0e26f7a"
    sha256 cellar: :any, arm64_sonoma:  "e51526f5bc4986724a7fbee4ba107e73013d1d229738c116c638027ac441d47f"
    sha256 cellar: :any, sonoma:        "16dc3c3f910761a01c85f21456bed4ce421d9d0a4a3a24e9a3b74bd4a3c46e18"
    sha256 cellar: :any, arm64_linux:   "45e819a6c660aab72f9718146de53ef3ba8951ea174fe4f956280508bd8dbac7"
    sha256 cellar: :any, x86_64_linux:  "2b8544e19ff689de38a3c156c04270fd575552aecec73516a70e3e3a5b29661e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~HASKELL
      foo =
        f1
        p1
        p2 p3

      foo' =
        f2 p1
        p2
        p3

      foo'' =
        f3 p1 p2
        p3
    HASKELL
    expected = <<~HASKELL
      foo =
        f1
          p1
          p2
          p3

      foo' =
        f2
          p1
          p2
          p3

      foo'' =
        f3
          p1
          p2
          p3
    HASKELL
    assert_equal expected, shell_output("#{bin}/ormolu test.hs")
  end
end
