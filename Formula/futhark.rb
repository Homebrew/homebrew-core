class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.1.tar.gz"
  sha256 "af9a94e957970a80d10519fee5039b15146c748e1c59936b4f40c0ccbbab98b5"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec574305e81c0254b611cc6aea805519211079dd1788cd9a6449bfb40bd560e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "813c000c8b4d3dd0cd3409df9b0528ec43aedd36666b6d82222b068cc1b388a8"
    sha256 cellar: :any_skip_relocation, monterey:       "bc1c0cb97d196e7a74c94ffc4f826146a5ed7374323abac7707dca5eb3ac1e85"
    sha256 cellar: :any_skip_relocation, big_sur:        "139e6c73f9c11d55b8c301c819b9f76e5d3857b410633ffa376e0cb70b444719"
    sha256 cellar: :any_skip_relocation, catalina:       "18d9fc8fb568b8e914a9c2548f4fd2b38cbfc1e2a5dde0b245797ab19d4d85b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75d6f3ae6eab82b6026b0d5266ce933d7c36e2106f8eeb270c937d42669a43ed"
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
