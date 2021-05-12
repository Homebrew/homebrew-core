class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.19.5.tar.gz"
  sha256 "b1a57cda8b3b16efa21742093c51b790939bc703d787491413c875779a68fa8f"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "198d61137b141bf43120943c38dc8844373fb98c200d9a6098e6cd29c19a5f90"
    sha256 cellar: :any_skip_relocation, catalina: "0b30142279435d5f8121c86322d4ca36d5a7f0164abe92f7e5e0aa2fc3fd555a"
    sha256 cellar: :any_skip_relocation, mojave:   "63a1cc382ee786c54bd2fbad440e7f1ee180b3e6697c187b5a4c58ab73fcba7b"
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
