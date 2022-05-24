class PandocIncludeCode < Formula
  desc "Pandoc filter for including code from source files"
  homepage "https://github.com/owickstrom/pandoc-include-code"
  url "https://hackage.haskell.org/package/pandoc-include-code-1.5.0.0/pandoc-include-code-1.5.0.0.tar.gz"
  sha256 "5d01a95f8a28cd858144d503631be6bb2d015faf9284326ee3c82c8d8433501d"
  license "MPL-2.0"
  revision 2
  head "https://github.com/owickstrom/pandoc-include-code.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03487512c8b41b88561df1e3e2f9d93ee09a6ea0381346c400417716a2b88b55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "116b050084dbeca5e70da5f02d8e71502ff6d2b971e27ef1fb4e8411b6678745"
    sha256 cellar: :any_skip_relocation, monterey:       "180d35d9d7e345bdfbdd2382aa4dfb2bc20ce1c2f0809b4a365c6cb0aca5e059"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc076e4b3a63c70309a63b8c631500418b0b9ba5db2a0a46718527fe780d5136"
    sha256 cellar: :any_skip_relocation, catalina:       "63300eec1d6a9e05208917453d202436384beaa35a50c9e46cff101bac589849"
    sha256 cellar: :any_skip_relocation, mojave:         "707af9306e01c8f183bad3232797c9220583a9cdba3baf7d99d77add6faccd87"
    sha256 cellar: :any_skip_relocation, high_sierra:    "46561ef2e3dbbc9b15cb84ca1b82f7c6510ed900ca3c6e7252d45eb00ac8c991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab22b3df53ac6762dcc8b564ebbefdc96a814ba31f93fc4dd701bbb28bacb958"
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
