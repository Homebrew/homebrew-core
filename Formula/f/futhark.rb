class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "8256fe44685d3a886c257244824c9af342139a2daf53d6f6882849a6bee8479f"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4b35ff7f7831d73267a59fb7b9bf38db52db3eaa351efda7d3af1179e738073b"
    sha256 cellar: :any, arm64_tahoe:       "68417d1cd253fa40af85fa93936e14fde559e7c21faff9a61d77503015b8897f"
    sha256 cellar: :any, arm64_sequoia:     "d21fdbaccf4cb68f05c30948ff0c99208616463c6afc9d10e6e480fec19c4a01"
    sha256 cellar: :any, arm64_linux:       "0ef89cba106755b2ecaf0826b4d77fe0b00a641d5c282a907f595464bcf2c457"
    sha256 cellar: :any, x86_64_linux:      "166a39f0504a7d62603b16b0bdd625c880154944015188ec76a48d162f9b5f5f"
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
