class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.3.1.tar.gz"
  sha256 "a3e8ab25dc53160da5e4bef58fe91107909ade6f93523227a935c5330d3ea8f7"

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
