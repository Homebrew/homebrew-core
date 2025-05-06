class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "1f972f070fa068a8a18b62016c9cbd00df994006e069647038694fc6cde45545"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "59b74bdb8e45b7e59e477aa7f5e0a3534a656181816010f4cd2811b0ff2de1f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2058530a9078298705f9fa4da7a7408a649aa9cdac2fd7983ee9bed2a8099ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c721712adf9cbc6c02517b8c912462b9ae9bb89d84654a4f6b2f83e877103d4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56ff572bce4302be865315fb8f3600dea1491f10bb527c808d88d3b6eea0cd24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a5ec25ca1ad776f4336830f309f63665c590521248e5a5d3a61bf6583f65b1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ce867b213ba400ed1b7e04cdb1f1046513d16b901a1533cf1c58ba981a3061d"
    sha256 cellar: :any_skip_relocation, ventura:        "4de41cd99e149ac7d69ad2c2be30870204072993af1c78789fdc025f58b4e256"
    sha256 cellar: :any_skip_relocation, monterey:       "1df703a623dc8dbb3423a593a9050ece0e560400a1bf07779968779e055e0fff"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed03ac5e81ded1c0e18ad0475d03ca708ea159939789b59049d63507bbe1be6f"
    sha256 cellar: :any_skip_relocation, catalina:       "85d88fda55b31414f8e91de69916c7c1ed8c3d48da54b7abab6fd09cdb8f195a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "76e71e292364be0910b7714d216e9c754e3947dcc3918cb011d0d9ca23963d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f4fbe6eb66d7e58700076ef0f4b3f775e441355ccdb7d65451d327536dc75e1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "xz"

  # Backport support for GHC 9.8
  patch do
    url "https://github.com/hadolint/hadolint/commit/593ccde5af13c9b960b3ea815c47ce028a2e8adc.patch?full_index=1"
    sha256 "dfa4e7a6c2c06f792d299ac17f13fbfd13654c35dea1dc202eda0601650e3b7e"
  end
  patch :DATA # https://github.com/hadolint/hadolint/commit/6a6dd09917d4b6c7c8fb5a5d8c31bb24e2a3b1e0

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~DOCKERFILE
      FROM debian
    DOCKERFILE
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end

__END__
diff --git a/cabal.project b/cabal.project
index 8b2b6d6e..40a32226 100644
--- a/cabal.project
+++ b/cabal.project
@@ -7,5 +7,5 @@ optional-packages:
 source-repository-package
     type: git
     location: https://github.com/lorenzo/shellcheck
-    tag: 07095b233a60b819df6710b7741a59bac62179e1
-    --sha256: 114yfgp40klrm32al93j7fh7lzzg7scqqnf8cc953h2m22k0c48q
+    tag: 248273935cd95afeaf835c688980ac5bccca8d14
+    --sha256: 1xm38l1fcq2agiwhh2jqikzinv5ldgnfazgir83xyv8r2v6x1ray
diff --git a/hadolint.cabal b/hadolint.cabal
index a0469934..7e6d01ab 100644
--- a/hadolint.cabal
+++ b/hadolint.cabal
@@ -147,14 +143,14 @@ library
     , containers
     , cryptonite
     , data-default
-    , deepseq >=1.4.4 && <1.5
+    , deepseq >=1.4.4
     , directory >=1.3.0
     , email-validate
     , filepath
     , foldl
     , gitrev >=1.3.1
     , ilist
-    , language-docker >=12.0.0 && <13
+    , language-docker >=13.0.0 && <14
     , megaparsec >=9.0.0
     , mtl
     , network-uri
@@ -169,7 +165,7 @@ library
     , time
     , timerep >=2.0
     , void
-  default-language: Haskell2010
+  default-language: GHC2021
 
 executable hadolint
   main-is: Main.hs
@@ -196,14 +192,14 @@ executable hadolint
     , containers
     , data-default
     , hadolint
-    , language-docker >=12.0.0 && <13
+    , language-docker >=13.0.0 && <14
     , megaparsec >=9.0.0
     , optparse-applicative >=0.14.0
     , prettyprinter >=1.7.0
     , text
   if flag(static) && !(os(osx))
     ld-options: -static -pthread
-  default-language: Haskell2010
+  default-language: GHC2021
 
 test-suite hadolint-unit-tests
   type: exitcode-stdio-1.0
@@ -321,10 +317,10 @@ test-suite hadolint-unit-tests
     , foldl
     , hadolint
     , hspec >=2.8.3
-    , language-docker >=12.0.0 && <13
+    , language-docker >=13.0.0 && <14
     , megaparsec >=9.0.0
     , optparse-applicative >=0.14.0
     , silently
     , split >=0.2
     , text
-  default-language: Haskell2010
+  default-language: GHC2021
