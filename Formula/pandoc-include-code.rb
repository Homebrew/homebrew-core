class PandocIncludeCode < Formula
  desc "Pandoc filter for including code from source files"
  homepage "https://github.com/owickstrom/pandoc-include-code"
  url "https://hackage.haskell.org/package/pandoc-include-code-1.5.0.0/pandoc-include-code-1.5.0.0.tar.gz"
  sha256 "5d01a95f8a28cd858144d503631be6bb2d015faf9284326ee3c82c8d8433501d"
  license "MPL-2.0"
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
