class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  stable do
    url "https://github.com/diku-dk/futhark/archive/v0.22.4.tar.gz"
    sha256 "5edf79ed2076192ead64efb8a4d30d05b56b2c1ec5bdd0905c33d6099d312850"

    # Use newer hackage snapshot to support GHC 9.4. Remove on the next release
    patch do
      url "https://github.com/diku-dk/futhark/commit/4b1eb18ca1ba6f8f8e9a15deed632eee5e5e5b5d.patch?full_index=1"
      sha256 "255487e20952f19ef8bdc812b9775220f8526c5823c630c13af7c7667bee9690"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cde37b2d259338ddea47ffa9891ca146eb05c93fc0c17979b2387ae5b40ad35a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67bb3657770861d0cbd137d41d5cfe42996d3575f0a17568eba4582bd3da69bb"
    sha256 cellar: :any_skip_relocation, ventura:        "d74907762132860969d642b075eb0e4d4053d3571118e282cdaed901ef311f8a"
    sha256 cellar: :any_skip_relocation, monterey:       "931ddbd6c489218eb4930fe67ed975a329a1d0ee8d0bac6fba016008e77c7a9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad4a3d57b6c629c89b86662966d8c2fb473adea14b945775d2377583a770c32b"
    sha256 cellar: :any_skip_relocation, catalina:       "831516499f46080702479c3c5f159a25910cadd10e9e68ca389e0b9f96f3779b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e2ef99b622e4fa78c70fc3156fa2825f00341c7ecfdc6c18d320f996b4b5e7"
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
