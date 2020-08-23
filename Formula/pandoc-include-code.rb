class PandocIncludeCode < Formula
  desc "Pandoc filter for including code from source files"
  homepage "https://github.com/owickstrom/pandoc-include-code"
  url "https://hackage.haskell.org/package/pandoc-include-code-1.5.0.0/pandoc-include-code-1.5.0.0.tar.gz"
  sha256 "5d01a95f8a28cd858144d503631be6bb2d015faf9284326ee3c82c8d8433501d"
  license "MPL-2.0"
  revision 1
  head "https://github.com/owickstrom/pandoc-include-code.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac41312b8211cc0602ac60025e9a0ef4a7f0479faabd56448858482ca09c9b8e" => :catalina
    sha256 "9f874b1fafe67861e38814a6411205a6f85c0808b6720ecd4cd68ada756ea484" => :mojave
    sha256 "d1a27c16d094b12858cddc4bc06744cdcfa1bd0d30b7de10030b4a0c7efbe058" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  # patch for pandoc 2.10, remove in the next release
  # patch ref, https://github.com/owickstrom/pandoc-include-code/pull/32
  patch :DATA

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

__END__
diff --git a/pandoc-include-code.cabal b/pandoc-include-code.cabal
index f587c70..0554824 100644
--- a/pandoc-include-code.cabal
+++ b/pandoc-include-code.cabal
@@ -36,14 +36,14 @@ library
                    , filepath
                    , text                 >= 1.2      && < 2
                    , mtl                  >= 2.2      && < 3
-                   , pandoc-types         >= 1.20     && <= 1.20
+                   , pandoc-types         >= 1.21     && <= 1.21


 executable pandoc-include-code
     hs-source-dirs:  filter
     main-is:         Main.hs
     build-depends:   base                 >= 4        && < 5
-                   , pandoc-types         >= 1.20     && <= 1.20
+                   , pandoc-types         >= 1.21     && <= 1.21
                    , pandoc-include-code

 test-suite filter-tests
@@ -53,7 +53,7 @@ test-suite filter-tests
                    , Paths_pandoc_include_code
     main-is:         Driver.hs
     build-depends:   base                 >= 4        && < 5
-                   , pandoc-types         >= 1.20     && <= 1.20
+                   , pandoc-types         >= 1.21     && <= 1.21
                    , pandoc-include-code
                    , tasty
                    , tasty-hunit
