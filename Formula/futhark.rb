class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.3.tar.gz"
  sha256 "2df81fbf19e8d79ef3a64a4729d6db56e4eede8a21bea390ecc7f441676d94fa"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c86320052a5a170691511bc75c7fcdfc4dcd9559718dc9756029f53065461ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e99fbd100523536e1bf8e663787e0db7ec6c9a134f9526e2ec9b2a3b67a8d93"
    sha256 cellar: :any_skip_relocation, monterey:       "2a1851d82ca5a8259d397261a34b67404025fa71221271aed2e5ce82f0a8f46a"
    sha256 cellar: :any_skip_relocation, big_sur:        "17fa62c99680f2b43f93e0690c5a115486cd882b3955f5539d759d65da70497a"
    sha256 cellar: :any_skip_relocation, catalina:       "2992f1dd48fc3039d6886541262aa62dcfb0d46340b1e8f5600cee1146dc51b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c54c65338438d6dbfb5d7dd5a8a40c94a0dfae9932153e6c91bf7e778fbbe09"
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
