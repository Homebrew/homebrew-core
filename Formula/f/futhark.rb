class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.36.tar.gz"
  sha256 "f2d07e4551db4f8c688a543f8f0609a575121f36f4034a44d6b907c39a3b5607"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "817066ce28606dd2816bc9a79b687766a42a82df136497fd385601108f6c8c83"
    sha256 cellar: :any,                 arm64_sequoia: "80694cd97164cf812f66a37303120991135462e51d5212f9d3f657a6295f26b7"
    sha256 cellar: :any,                 arm64_sonoma:  "0abbd015f8518b3b25e5d3123c50d48e04ecf8eb798eeb0cf26d1dacca09f3e8"
    sha256 cellar: :any,                 sonoma:        "70adf8013b74c45f34986530f77bde00d9d5e1b92e5e11c028905ded19cf1a4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3992d24c9c99ed0ff597487e4ad66eee1f0054f37cf553f20e3678898378dd7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "859ae48691641a71b190971d4299a149ce1692b4ce81ce4f5a99ed7be771aa99"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
