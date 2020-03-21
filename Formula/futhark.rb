require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.15.2.tar.gz"
  sha256 "81816386aaf649f967b75bd411cecc6026f3fedf58d15f84c4f305c30a6631c6"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "617749922c76b3deb41dac499f4a6d507ad1327769132bae615023e78ea4c475" => :catalina
    sha256 "056a06f503ecfb1d88066776dc40512c13c1cfd7051069d9e5029f2a3c15ee9e" => :mojave
    sha256 "793f6eb1f8d859a31a47f647d6e7c6368b128bec0e94b3e15fde3e8373afeac3" => :high_sierra
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
