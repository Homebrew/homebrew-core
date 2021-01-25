class PandocIncludeCode < Formula
  desc "Pandoc filter for including code from source files"
  homepage "https://github.com/owickstrom/pandoc-include-code"
  url "https://hackage.haskell.org/package/pandoc-include-code-1.5.0.0/pandoc-include-code-1.5.0.0.tar.gz"
  sha256 "5d01a95f8a28cd858144d503631be6bb2d015faf9284326ee3c82c8d8433501d"
  license "MPL-2.0"
  revision 2
  head "https://github.com/owickstrom/pandoc-include-code.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dc076e4b3a63c70309a63b8c631500418b0b9ba5db2a0a46718527fe780d5136" => :big_sur
    sha256 "63300eec1d6a9e05208917453d202436384beaa35a50c9e46cff101bac589849" => :catalina
    sha256 "707af9306e01c8f183bad3232797c9220583a9cdba3baf7d99d77add6faccd87" => :mojave
    sha256 "46561ef2e3dbbc9b15cb84ca1b82f7c6510ed900ca3c6e7252d45eb00ac8c991" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  # patch for pandoc 2.11, remove in the next release
  # patch ref, https://github.com/owickstrom/pandoc-include-code/pull/35
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
+                   , pandoc-types         >= 1.22     && <= 1.22


 executable pandoc-include-code
     hs-source-dirs:  filter
     main-is:         Main.hs
     build-depends:   base                 >= 4        && < 5
-                   , pandoc-types         >= 1.20     && <= 1.20
+                   , pandoc-types         >= 1.22     && <= 1.22
                    , pandoc-include-code

 test-suite filter-tests
@@ -53,7 +53,7 @@ test-suite filter-tests
                    , Paths_pandoc_include_code
     main-is:         Driver.hs
     build-depends:   base                 >= 4        && < 5
-                   , pandoc-types         >= 1.20     && <= 1.20
+                   , pandoc-types         >= 1.22     && <= 1.22
                    , pandoc-include-code
                    , tasty
                    , tasty-hunit
