class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.20.4.tar.gz"
  sha256 "958f6c41d3a1002d5c2ccc2c8e1355dbabcfcca0e9b538c9babc81848860b6e1"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "217e1f392f74ae06af2912fb864c73ab0e3c5632a8fc9511f10437c4ae1efaeb"
    sha256 cellar: :any_skip_relocation, big_sur:       "0a1e263e927643bd26d69831c8f5590186c581e921204d480e2fed29145d52b1"
    sha256 cellar: :any_skip_relocation, catalina:      "b6fad661d6e5d8296128b256cc4fa5031584ff21f0827b318e23de5b2a83616a"
    sha256 cellar: :any_skip_relocation, mojave:        "97c2af42b567929c2e5a982f4bca6cb4509abd049561ef9aac067b7dc4b215d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0655ac5c57a56c3f66efa05727d97290f40c842a1db7e22e03b56ff67245a1d2"
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
