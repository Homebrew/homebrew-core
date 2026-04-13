class Hindent < Formula
  desc "Haskell pretty printer"
  homepage "https://github.com/mihaimaruseac/hindent"
  url "https://github.com/mihaimaruseac/hindent/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "2726bdbf137691624997f181c29392f22f8566ebc87c5f82e420adfb0068ef07"
  license "BSD-3-Clause"
  head "https://github.com/mihaimaruseac/hindent.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a9064e9f051f701b3838a050166eb32ff0d3b63658931e8d2e29ed6805b4a2e2"
    sha256 cellar: :any,                 arm64_sequoia: "7e8875034d3dd3f855cce38ce39f5b0e08b4f9cd712f2af63134372b0ee17261"
    sha256 cellar: :any,                 arm64_sonoma:  "4f100aab2d28aa161eadcd116b80f475ab2fff06f4285a58f5a6a170c7a0b7fc"
    sha256 cellar: :any,                 sonoma:        "abaaaad9675273a1b29ecac2a408e184828dcdcfa51a15c2fb1c5ef3faa28892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6c786888802e34042a222067dde33ae147d1d44ce79ec04be7547dc442068ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc168486315c2d03459ab2025810d2c88c6e8268c0f1b3d938cfd7ea29d390e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build # GHC 9.14 issue: https://github.com/mihaimaruseac/hindent/issues/1155
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hindent --version")

    input = <<~HASKELL
      example = case x of Just _ -> "Foo"
    HASKELL
    expected = <<~HASKELL
      example =
        case x of
          Just _ -> "Foo"
    HASKELL

    assert_equal expected, pipe_output("#{bin}/hindent --indent-size 2", input, 0)
  end
end
