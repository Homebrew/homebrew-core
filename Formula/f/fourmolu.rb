class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/refs/tags/v0.16.2.0.tar.gz"
  sha256 "3d4b36afaa6343f66f2cebb6df921aa51b796d0843a838a92627222112590166"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0169d9e5786ce1d71d444ced3c11344de7f68bde62731e00b36bca9a602d5b6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf0db02a0898164b2824384a580c6b5522425374f368e7b2f4f7fca16b8709f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0acac9a764b3e4c3685594c235eccbec37f2b7079a749e4eaf9cfdb4018f41ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "065133a0fe25829429bdc552ad223196aca2c5ef12a019615491b04b0ffb3f34"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cb449484c73336957da14fd5589d6e7f7d981ba4a4bfa81ecf5e58fc620c733"
    sha256 cellar: :any_skip_relocation, ventura:        "7d6e90ad267ad10e1825a5cc86acb814b9a7652738db9fa48357af0782ba3683"
    sha256 cellar: :any_skip_relocation, monterey:       "aab423c353efb09f503d3b502b6e513f91b76bb73be35f70bb64eb5753babfd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "396190a4f8bd9a84a887cfbd4fc906a4bc6995beadad477af8968f6fe52ead12"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
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
    EOS
    expected = <<~EOS
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
    EOS
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end
