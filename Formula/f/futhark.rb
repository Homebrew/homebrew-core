class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "f9f1f3658790ed99ac4e3d9af30d6eb195effeb242c9d58bb925a3c37f6c0af8"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dcb62c642d030bbe03597a2b03f6392430acbfe78f06a97fabf00b4568e7cf1b"
    sha256 cellar: :any, arm64_sequoia: "ed34e3d0aa1769273fc1dd713c243a141a5f204117f2d5ab375847b4b2034396"
    sha256 cellar: :any, arm64_sonoma:  "92f4fa03b9d3036e8f6109872431c16c7efb2efb829b0f977bc869f399643224"
    sha256 cellar: :any, sonoma:        "97793b05bd640e0c1a5877b5fa590e5d7affc9c6e7848ffff3bcaf1d37e94a7f"
    sha256 cellar: :any, arm64_linux:   "5b5edcc1caa0c44977daa2550e7088394afd47d74c596fd091b232a84e76ca34"
    sha256 cellar: :any, x86_64_linux:  "cd0764603d9c5ec90a1a4aef56b09520300ccfda9962c3c46e856db413a65cbc"
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
