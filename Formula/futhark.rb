class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.4.0.tar.gz"
  sha256 "238ead153c3e1656237994b3036de074265d85dba7fda1786efd9bb22789d04b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d96eed912720a404cb42c5fb6af5a75683c258e85d19b377e393859e6002fe07" => :high_sierra
    sha256 "7672b05d9cb4c4c8be180ff570ead0d4a843d45951abd1424d3c03884957e471" => :sierra
    sha256 "a297d156ae380db6ab1ad3caa0cc0dca4b09bcf942d5541000e190e04da46cda" => :el_capitan
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
