class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.10.0/cryptol-2.10.0.tar.gz"
  sha256 "0bfa21d4766b9ad21ba16ee43b83854f25a84e7ca2b68a14cbe0006b4173ef63"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3602fbe74d5bba84b2e36ea3e5860b4a8ca3be54a2c13b57dff69621673d1a26"
    sha256 cellar: :any_skip_relocation, catalina: "42bbe475407645974fb9e90c6811ca103c2d7d92ec5d622428f753fd7f9077b0"
    sha256 cellar: :any_skip_relocation, mojave:   "e2dc3e5f38a0bb0f0bd288d9847be8be769e97ab1385b775daa1b35249fd4bff"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Patch to fix build failure with incompatible version of libBF
  # https://github.com/GaloisInc/cryptol/issues/1083
  patch :DATA

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end

__END__
diff --git a/cryptol.cabal b/cryptol.cabal
index 077e927..2a3cb8e 100644
--- a/cryptol.cabal
+++ b/cryptol.cabal
@@ -56,7 +56,7 @@ library
                        GraphSCC          >= 1.0.4,
                        heredoc           >= 0.2,
                        integer-gmp       >= 1.0 && < 1.1,
-                       libBF             >= 0.5.1,
+                       libBF             == 0.5.1,
                        MemoTrie          >= 0.6 && < 0.7,
                        monad-control     >= 1.0,
                        monadLib          >= 3.7.2,
