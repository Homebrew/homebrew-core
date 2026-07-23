class Ormolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://ormolu-live.tweag.io"
  url "https://hackage.haskell.org/package/ormolu-0.8.1.1/ormolu-0.8.1.1.tar.gz"
  sha256 "152ece29b91e79f25d2c7aca3da1a15aba3251c5a751e680c3cbcf95b8681476"
  license "BSD-3-Clause"
  head "https://github.com/tweag/ormolu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "91b289a3ec2074f9ed6c0768ffc7ffc1ff93eb4719f4ded7d1b31b7d0fff583b"
    sha256 cellar: :any, arm64_sequoia: "2a505c97847820d395bb2ade699376df672a65560e649051e2cb329bc12fbad0"
    sha256 cellar: :any, arm64_sonoma:  "aa5bdfbf1bd742b63dfc401dbd68eaf73ea735802e0334ad3e121d1648740f81"
    sha256 cellar: :any, sonoma:        "a4b3eb580fccad915da8972b223184877869409f5d31a4288a5d2679c34747bb"
    sha256 cellar: :any, arm64_linux:   "4d16757eba28b37a9220890af7928100ee794f8cd5072f93abf08948f733b330"
    sha256 cellar: :any, x86_64_linux:  "c7f1494263ad7fbbc2d951d248ade77b22903c6306b1e38b95105f83a99f4f02"
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
