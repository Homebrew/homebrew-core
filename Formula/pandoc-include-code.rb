class PandocIncludeCode < Formula
  desc "Pandoc filter for including code from source files"
  homepage "https://github.com/owickstrom/pandoc-include-code"
  url "https://hackage.haskell.org/package/pandoc-include-code-1.5.0.0/pandoc-include-code-1.5.0.0.tar.gz"
  sha256 "5d01a95f8a28cd858144d503631be6bb2d015faf9284326ee3c82c8d8433501d"
  bottle do
    cellar :any_skip_relocation
    sha256 "00437f205875a67ba6131e7e6643c0d947d5fe7bcbfa5cdd0c8640e863f827ac" => :catalina
    sha256 "901fd1495a596e376ba96e744333726f80eeef0a0c97571c1ab871167822894d" => :mojave
    sha256 "86aaeb61035401d0288d5352ee6613e688c3d22ff26f785e76ef5065cf13f993" => :high_sierra
  end

  head "https://github.com/owickstrom/pandoc-include-code.git"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      ```{include=test.rb}
      ```
    EOS
    (testpath/"test.rb").write <<~EOS
      puts "Hello"
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-include-code", "-o", "out.html", "hello.md"
    assert_match "Hello", (testpath/"out.html").read
  end
end
