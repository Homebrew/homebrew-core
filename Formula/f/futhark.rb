class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  # TODO: Try to switch `ghc@9.4` to `ghc` when futhark.cabal allows base>=4.17
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.11.tar.gz"
  sha256 "89778c728202ec8f13146509b902f8362af3ed1433d510e2956217dbd0c682bf"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b1092d723d9c5e78ef5627a46c8f423b80ece3af1a17e994918b07375f69cbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "622156b2888e1fe812e58052a42f58893aded8ef53003406acb21985cc690926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6a1c829810ba9dd15e4dbc5e7b2bb26f40d61bc2fbf06206c7188298d4f4a95"
    sha256 cellar: :any_skip_relocation, sonoma:         "d376194d48cad13f3f6f0b88da2216bba6a6199843fa41e29b06cc3853f8ea02"
    sha256 cellar: :any_skip_relocation, ventura:        "57314b29d1a8893cb1cf50cc8938aa1f3d3ac75bf2dbf6363595c1fa531a1810"
    sha256 cellar: :any_skip_relocation, monterey:       "96287b050d76aaed52a39e8994cea618f54f29c7f85679b02e432ee165da7003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "250a57558061b54450327079de707a9f2271aa5955d4379abcc6f8763a04a8d5"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
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
