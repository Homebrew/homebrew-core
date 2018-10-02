require "language/haskell"

class PandocIncludeCode < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for including code from source files"
  homepage "https://github.com/owickstrom/pandoc-include-code"
  url "https://hackage.haskell.org/package/pandoc-include-code-1.3.0.0/pandoc-include-code-1.3.0.0.tar.gz"
  sha256 "84c5f27a358b4a39606761157de93152c304b3a7d4e27cd30391c2a93cd495ce"

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    (testpath/"include-demo.md").write <<~EOS
      Demo for pandoc-include-code.
      A simple C code from source file.

      ```{include=hello.c}
      ```
    EOS
    (testpath/"hello.c").write <<~EOC
      #include <stdio.h>
      int main(){
        print("Hello, World!");
      }
    EOC
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-include-code", "-o", "out.html", "include-demo.md"
    assert_match "Hello, World!", (testpath/"out.html").read
  end
end
