class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.1.tar.gz"
  sha256 "af9a94e957970a80d10519fee5039b15146c748e1c59936b4f40c0ccbbab98b5"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f56c2c5f84554f4b438498768dad2bbc5116b644a9395dc075b81251c0149a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31e1e95734bfd8ebab6f161b7fdec432e4298a7cc726b18fa5fba2c150183454"
    sha256 cellar: :any_skip_relocation, monterey:       "95d7283b98802cb6bdbeadc3f06d65d96ff1a65c6538892e65b3edefdbb23879"
    sha256 cellar: :any_skip_relocation, big_sur:        "9edbb8c562b60e85d56fa75c681f75d8d8452739b4edaa8f4f8294f28ce3abea"
    sha256 cellar: :any_skip_relocation, catalina:       "c12481d906075e0ce7723442ead6570c412684d14dc0222e0dfdef67b6d628b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e83d9587d8d5be1a58316048b0c8f0583ca1806761129c2af70d9aef1fceef4b"
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
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
