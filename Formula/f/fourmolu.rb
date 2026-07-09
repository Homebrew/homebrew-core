class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://fourmolu.github.io/"
  url "https://hackage.haskell.org/package/fourmolu-0.20.0.0/fourmolu-0.20.0.0.tar.gz"
  sha256 "34a3cedc64042e4f36bf7a94bae1e11d43a1571933ceb96e5d838447b3bd17b9"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1ba2b3771a07e21c9c9f61bee8105d23250ee344afb59e002b2cf74ec4ff5f32"
    sha256 cellar: :any, arm64_sequoia: "e6c8bced90f2b3076e28fbd188b1ba802c5810f345ccd806e4b7a82a4d2e1c3c"
    sha256 cellar: :any, arm64_sonoma:  "29abc041e5ae0379ab49e31ed5e6d6dd62a57ef45def293c4db9577b1aa197a5"
    sha256 cellar: :any, sonoma:        "31cc893c4c444867a6ac86c26ce3c48654692b2017d0b96e6695a00326396b69"
    sha256 cellar: :any, arm64_linux:   "9b507a8afa0ccb179fa65ac430312ab496688c683a12200937b494df2f50d506"
    sha256 cellar: :any, x86_64_linux:  "4bf7d3c191e158ccc167bd15f6bd502533dc29017a08262c6d3adb67583941f1"
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
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end
