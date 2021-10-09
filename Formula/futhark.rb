class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.20.4.tar.gz"
  sha256 "958f6c41d3a1002d5c2ccc2c8e1355dbabcfcca0e9b538c9babc81848860b6e1"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45b9520e676f20f8048d7b7ce812db45ad2895625b70e6d4ae70b69a372a2104"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad72e44ea0fc9db137ebe8ad1db5eec6d2a1dee8696b53c84d25fa918531b04b"
    sha256 cellar: :any_skip_relocation, catalina:      "297d35208978002ceee4f0ddde9ee74b985c9b58165a18ba34f34ce6d65aa9af"
    sha256 cellar: :any_skip_relocation, mojave:        "ada26ecee2c0deb32791d04226a52c8025e0e21d61878c163500b7f2fd3b90c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6e8594e03271cb0eb9e16ed04dee29cac345f14c92ab7f9efc95bcf81a2e2b"
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
