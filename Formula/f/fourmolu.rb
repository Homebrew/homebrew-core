class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/refs/tags/v0.18.0.0.tar.gz"
  sha256 "9aa651611f15091261e1de9322ff7726954711172cec17bf61b179d3cbd70c1b"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2d9ce758465785f3ca94fa81e0eb51ce18d0cc967608fa08178d1a2f6f4e61c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c49416e68dda86b5f12e99c9df0dab041273dd80ac37665d1b8d452189cc6dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9441f01027d37ddf2e858a4de858b581c4c5dfc4b2d725b54d6bdc662c38d6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e781261155de2f1e7380503ff6e11113df11fa570538e653e5c40d8ecb14ccf5"
    sha256 cellar: :any_skip_relocation, ventura:       "4a5f366a75f763b629a4544fa762cabeac3dae37194ab25987e782bd23eb797e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae06accc25d07d09c47ce4fdf24f10a7c08ea0a0f6f1b0a2e45cf2dda5c63ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47cee8a9a89a790eddb07bdf4aebe741240a25ac37fed400dbd7c69f94510dec"
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
