require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.15.3.tar.gz"
  sha256 "0f13890f9e2eb0b487be53a2c26c71d1bad19a9ba7a6fc5e72f3c03cfbe6c220"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4c9f6fa2fa1faa1ed3197779a3df29374be8f00a87773c272a4e4d96bff35f1" => :catalina
    sha256 "d61886843de065ac46e1674880c36f0b830cb47d9fa32463ee77fc3bf3402c64" => :mojave
    sha256 "e726a5876f27bde35703e19bb3a78c8e8b3c29e2254dda99c0a7002b96b4e166" => :high_sierra
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
