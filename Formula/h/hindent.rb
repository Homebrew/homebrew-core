class Hindent < Formula
  desc "Haskell pretty printer"
  homepage "https://github.com/mihaimaruseac/hindent"
  license "BSD-3-Clause"
  head "https://github.com/mihaimaruseac/hindent.git", branch: "master"

  stable do
    url "https://github.com/mihaimaruseac/hindent/archive/refs/tags/v6.3.0.tar.gz"
    sha256 "2726bdbf137691624997f181c29392f22f8566ebc87c5f82e420adfb0068ef07"

    # GHC 9.14 support
    patch do
      url "https://github.com/mihaimaruseac/hindent/commit/38e5fff0a224dd2137bb6ee4cace6ae792b6a527.patch?full_index=1"
      sha256 "14d79ab840c44d8a1991f38d0d3d34bcd246f3148fa7cfaec1e3c28e1445e91e"
      type :backport
      resolves "https://github.com/mihaimaruseac/hindent/issues/1155"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "e8ab81d0caf17d6c2834d90e76481868c73f0d8a1cd636ed02c33e2362d7b669"
    sha256 cellar: :any, arm64_sequoia: "db776bdb9ae061d14d2863d2dc1baac79033855793f36f7ca7eeb0576624f26c"
    sha256 cellar: :any, arm64_sonoma:  "336147fde1d403757ede257d316008b5ef457eb3603b790c7a8907f08edd245f"
    sha256 cellar: :any, sonoma:        "333600903abc0b0b0dfb649e3afb7cf4e794bdb66d78f4112ddbce461460c72b"
    sha256 cellar: :any, arm64_linux:   "da224e795271d01684762d7ad21b7e3f9e74fa61bf136a773d38e107b33d0141"
    sha256 cellar: :any, x86_64_linux:  "e8f838f6c8f27a13b50575b8cd9f3ee25278acffca98f47b12fddcdb9d6e6120"
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
