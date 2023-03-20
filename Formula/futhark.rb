class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.24.1.tar.gz"
  sha256 "f56fae52411ed951df613d3ec914118bb573f42f155f46d243f813108cb2c494"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62f2afc3684cf58a38bfbcaa8ecb2b5a9aca93a96ee0fa20e028f5f18c106c7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95ff91da66f58e1955511b45030c88c4a6d2f6a377e01547617b123c88a61861"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54d6cafc9af24f8d922c3e8abaa6d99def6f663d7fb301c1f90461f800f1eb49"
    sha256 cellar: :any_skip_relocation, ventura:        "2c7fa181d85998a9dd67c1f3ed14ad99cc4fa33a905533cb38b2a6d0608c5659"
    sha256 cellar: :any_skip_relocation, monterey:       "c45c497203357fb11e908785faf8bbaaaa2504c69f06b61a825b4e104a5d43bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "87bc4223f439068eef0f263d7d08ce774a47c3540f0eb7a2fb7d98822ede6042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f105dbe4e1c15dffb01d7b0080a4592263c7a50640c8bee0419f2cc0c827ba0f"
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
