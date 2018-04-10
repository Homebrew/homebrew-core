class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.4.0.tar.gz"
  sha256 "238ead153c3e1656237994b3036de074265d85dba7fda1786efd9bb22789d04b"

  bottle do
    cellar :any_skip_relocation
    sha256 "7eae369141986e4700ecb0eaef9bdf8023662b9536146750166bb73d5ccdc072" => :high_sierra
    sha256 "7c737eb7d6f4b47989c267981c0e027cd4d6803cf3d090e80b4628f02ccdced8" => :sierra
    sha256 "4f756fc94617e0902349587670bfce54bd497116bf16b44a3a5c3c34e23871d4" => :el_capitan
  end

  depends_on "ghc@8.2" => :build
  depends_on "haskell-stack" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "stack", "-j#{ENV.make_jobs}", "--system-ghc", "--no-install-ghc",
           "--local-bin-path=#{bin}", "install"

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark-c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
