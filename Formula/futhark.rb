class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.3.1.tar.gz"
  sha256 "a3e8ab25dc53160da5e4bef58fe91107909ade6f93523227a935c5330d3ea8f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea02afdd567ef66b13788b8ded07c12e7ee3d17e4289de694d293e2dd3ac16d3" => :high_sierra
    sha256 "58fb132a709bfdb3d4aba3ca8f4bf8acc35f42847e1a6859b499f2e6c58dead5" => :sierra
    sha256 "be8f8db352fdd341b9dc29dd0a11d15c6d12230f076852e854903f2643f2727e" => :el_capitan
  end

  depends_on "haskell-stack" => :build
  depends_on "sphinx-doc" => :build

  def install
    # Avoid touching the user's own .stack_root
    ENV["STACK_ROOT"] = Pathname.pwd/"stack_root"
    system "stack", "--local-bin-path=#{bin}", "install"

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark-c", "test.fut"
    assert_equal "3628800i32\n", pipe_output("./test", "10")
  end
end
