class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.18.5.tar.gz"
  sha256 "62e40af86afb357cf443861ae4f10662effff42f2981d103943ea20aefc6d076"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b509a18e2eb41e66a85c7f654a80a6fe58adfca07c46d32b5b50abf92a40d530" => :big_sur
    sha256 "d1cd16cbd7ea1cedb79facaff8a6e882f379c5e24dd9d9919ca772d686a15717" => :catalina
    sha256 "42a14f360798bf51d8262706c1b1c36c71a073bb162fa46f5001892db71aec05" => :mojave
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # Remove the `--constraint` flag at version bump
    # see https://github.com/ddssff/listlike/issues/8#issuecomment-748985462 for detail
    system "cabal", "v2-install", *std_cabal_v2_args, "--constraint=bytestring==0.10.10.1"

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
