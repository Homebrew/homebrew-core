class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.18.3.tar.gz"
  sha256 "670c9fa4264f68df22a7fe30e4f5710235eeb30cbebb6b34751347264165d4fd"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "334d72f32e477ff87ed21faa8d21e065ac3cb228c572a1b80a394201634b76f4" => :catalina
    sha256 "c4714889d9c830626b6d3a559ed2a8dad02c052f3f866f69ae876960e366f100" => :mojave
    sha256 "75765bfb4335e08df2a03896eb1cb588df6e9e4b9dd5ac6f03286554396b8e9c" => :high_sierra
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
