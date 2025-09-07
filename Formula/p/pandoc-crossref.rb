class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.20.tar.gz"
  sha256 "935d66e4b52323aba625b2bfa90abfea774816ccf4feb959e8271beac6d9b453"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74d51e468d495edd3e4c095a3622e9061cdac17c821f6dd7413c1d164b417ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e46fc078835657efdb599697aa350ec00162cd31e41f2b8b92d8e20e94744a0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fe60c0d48d2caafbb8b671fbed7d2434a0097bbb32f01953e3b46c35a82fa40"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc0f3c9b025b95fa2eef1ca33b7e12a484326aba0f277f7496c2b74035dec7f"
    sha256 cellar: :any_skip_relocation, ventura:       "936561b8adb00d74f6fc95f8ee7178b6a02897215585b4f03382fb5bce456e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f352c2f63a4b94c7bfdf4357b021996e76dbe48e5a5172ac071bd14dc9cedb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91b1a3ea50bced573f3fab7df9e5f21e0f86d511f21a98f69ad5ed87745b6295"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  # upstream bug report, https://github.com/lierdakil/pandoc-crossref/issues/482
  patch :DATA

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end

__END__
diff --git a/package.yaml b/package.yaml
index eae4b5a..c7455c0 100644
--- a/package.yaml
+++ b/package.yaml
@@ -30,7 +30,7 @@ data-files:
 dependencies:
   base: ">=4.16 && <5"
   text: ">=1.2.2 && <2.2"
-  pandoc: ">=3.7.0.2 && < 3.8"
+  pandoc: ">=3.7.0.2 && < 3.9"
   pandoc-types: ">= 1.23 && < 1.24"
 _deps:
   containers: &containers { containers: ">=0.1 && <0.7" }
diff --git a/pandoc-crossref.cabal b/pandoc-crossref.cabal
index 5270aa1..48a796f 100644
--- a/pandoc-crossref.cabal
+++ b/pandoc-crossref.cabal
@@ -169,7 +169,7 @@ library
     , microlens >=0.4.12.0 && <0.5.0.0
     , microlens-mtl >=0.2.0.1 && <0.3.0.0
     , mtl >=1.1 && <2.4
-    , pandoc >=3.7.0.2 && <3.8
+    , pandoc >=3.7.0.2 && <3.9
     , pandoc-crossref-internal
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
@@ -223,7 +223,7 @@ library pandoc-crossref-internal
     , microlens-mtl >=0.2.0.1 && <0.3.0.0
     , microlens-th >=0.4.3.10 && <0.5.0.0
     , mtl >=1.1 && <2.4
-    , pandoc >=3.7.0.2 && <3.8
+    , pandoc >=3.7.0.2 && <3.9
     , pandoc-types ==1.23.*
     , syb >=0.4 && <0.8
     , template-haskell >=2.7.0.0 && <3.0.0.0
@@ -253,7 +253,7 @@ executable pandoc-crossref
     , gitrev >=1.3.1 && <1.4
     , open-browser ==0.2.*
     , optparse-applicative >=0.13 && <0.19
-    , pandoc >=3.7.0.2 && <3.8
+    , pandoc >=3.7.0.2 && <3.9
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , template-haskell >=2.7.0.0 && <3.0.0.0
@@ -283,7 +283,7 @@ test-suite test-integrative
     , directory >=1 && <1.4
     , filepath >=1.1 && <1.6
     , hspec >=2.4.4 && <3
-    , pandoc >=3.7.0.2 && <3.8
+    , pandoc >=3.7.0.2 && <3.9
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
@@ -319,7 +319,7 @@ test-suite test-pandoc-crossref
     , microlens >=0.4.12.0 && <0.5.0.0
     , microlens-mtl >=0.2.0.1 && <0.3.0.0
     , mtl >=1.1 && <2.4
-    , pandoc >=3.7.0.2 && <3.8
+    , pandoc >=3.7.0.2 && <3.9
     , pandoc-crossref
     , pandoc-crossref-internal
     , pandoc-types ==1.23.*
@@ -348,7 +348,7 @@ benchmark simple
   build-depends:
       base >=4.16 && <5
     , criterion >=1.5.9.0 && <1.7
-    , pandoc >=3.7.0.2 && <3.8
+    , pandoc >=3.7.0.2 && <3.9
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
