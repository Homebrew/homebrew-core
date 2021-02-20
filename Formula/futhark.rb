class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.18.6.tar.gz"
  sha256 "18160d818b4d829f3be8e44c91321ebf2a57966c12e36297b4f7fc843e1ebf9d"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "78ff19cb1a0401b22b4cce9826e2eac73422522d12a0d020048a08cfbec90450"
    sha256 cellar: :any_skip_relocation, catalina: "9e65d0b791aa78acc70703204979d5568709902d58d41e894ef4e03c5a67d01b"
    sha256 cellar: :any_skip_relocation, mojave:   "2442eb9b0daf821cd775413a3d94a55e2e799f640fa87d32e6b6708a743a81d1"
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
