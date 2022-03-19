class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.8.tar.gz"
  sha256 "830579b3e45b97a2e9e1ca423a271d311fb84ebf1b2a9f1ed4063d2408ac2dca"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9fcd9ce6e1b97e455d2b6a20218af81ab42683da0cbb0d9ca4c0956a6cfdc16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f9ae83e9946620fee7d10475e70e9ca0e99db4246ab0a6dce619be23009219d"
    sha256 cellar: :any_skip_relocation, monterey:       "997eb22d3e5567baaabc387653d386e5dbbd1997dd3d6b2395a9f4704e5ea092"
    sha256 cellar: :any_skip_relocation, big_sur:        "c880dd6a021db998e4ba2a4b564ee4f302d32bd21f5f41ec7a6230a7e79ebe58"
    sha256 cellar: :any_skip_relocation, catalina:       "734f31827152c84ccd4482524f935638525a1af4a087eae7188ab293f27902f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f39b77348e06c4bc4be9465a636d661ce7dd9a273a95ba6d665412d1e380a969"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
