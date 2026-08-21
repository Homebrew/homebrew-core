class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://fourmolu.github.io/"
  url "https://hackage.haskell.org/package/fourmolu-0.20.1.0/fourmolu-0.20.1.0.tar.gz"
  sha256 "345e420b6871852b6148caa26a23991f7646786377276716dd36ae5a6cd842c9"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "acc98406429fac5fa1ed83c9f36df396a4f802987aa164518380077cf9c290ec"
    sha256 cellar: :any, arm64_sequoia: "05b8da7c1aee0cdfa5994ac1eae2731ef2a890ad5e978d28fe864148eb646726"
    sha256 cellar: :any, arm64_sonoma:  "21a8f3a16680ef22d8f4d31a57216062ec1173c80181f6cae4b4d7039526bf7c"
    sha256 cellar: :any, sonoma:        "fb5f5bed2efa7f8ac9494ec6a3b0cebfc36f028f8028c1ffddd49bcffbf3f21d"
    sha256 cellar: :any, arm64_linux:   "ba2e99eb466748ec13d75dbdf00423e9cf9cc0c6808bc47f39536571979c9e44"
    sha256 cellar: :any, x86_64_linux:  "252f46576468737725049ac2f14e1e3f2506b3a1c6ef3a153d06a8c7e1369619"
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
