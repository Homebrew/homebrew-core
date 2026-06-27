class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://ormolu-live.tweag.io"
  url "https://hackage.haskell.org/package/ormolu-0.8.1.1/ormolu-0.8.1.1.tar.gz"
  sha256 "152ece29b91e79f25d2c7aca3da1a15aba3251c5a751e680c3cbcf95b8681476"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7ee24c452fa91ca3cbfee3a413439c40601b91d75a29042a5b84015a264f0913"
    sha256 cellar: :any, arm64_sequoia: "85db5a65b36e35e8732fadd720a271640c61759b94b3bed5e99200711d78993a"
    sha256 cellar: :any, arm64_sonoma:  "60bb6a3bb60956311284eaf177b03df7ac531a758b7f7ef2604e974377b9d6c0"
    sha256 cellar: :any, sonoma:        "9f4776fc068def179afd79e064fdda9c5ed49d2e3b0716899d7886b5dfe22150"
    sha256 cellar: :any, arm64_linux:   "875f3c6225f1b1f25532b1dcb8f3d90e8339b1ec637e0e3f0eb7f8de4bc4b7e3"
    sha256 cellar: :any, x86_64_linux:  "698f8f59a9d87fa859a37d3b6b523e9a9c1a5b3fc72d1db862f5d082e27ffc58"
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
