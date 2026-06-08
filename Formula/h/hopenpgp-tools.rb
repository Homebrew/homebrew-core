class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  # TODO: Check if `ixset-typed` resource can be dropped
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.11/hopenpgp-tools-0.23.11.tar.gz"
  sha256 "2a056bd320caafe0f7ac3c95d56819f9fef02ddafe11b59802ea5a678d88a54f"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ed34e785a3cbeff6ea95e7b39aeda7f414e0da121428eb90dd8642c4ec28226"
    sha256 cellar: :any,                 arm64_sequoia: "91215b8ed2b56500b6827ddb3a0ffe02c97f11312a1bd23d2dee8e0c9597b243"
    sha256 cellar: :any,                 arm64_sonoma:  "2892ccd7b57f203042e950e4806a1b1cfe970374a6d88a9a45de3ddba22cd050"
    sha256 cellar: :any,                 sonoma:        "a483c64b027cd0275d5ff317052e708c706f79054f1b3b130e1fbf4ffc657e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "804a0866e6ee6e795186d87f5c963de1e33589899650792f925dfce6735fa569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caf063335e13be6ddb1511d2b586659bf80e345b0e53008283a12421ba548a68"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gnupg" => :test
  depends_on "gmp"
  depends_on "nettle@3" # https://github.com/stbuehler/haskell-nettle/issues/12

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # TODO: Remove resource once new release ixset-typed release is available
  resource "ixset-typed" do
    url "https://hackage.haskell.org/package/ixset-typed-0.5.1.0/ixset-typed-0.5.1.0.tar.gz"
    sha256 "08b7b4870d737b524a8575529ee1901b0d8e39ff72298a6b231f8719b5a8790c"

    # Backport https://github.com/well-typed/ixset-typed/pull/23
    patch do
      url "https://github.com/well-typed/ixset-typed/commit/460901368dcb452d352a17bcd4b8f60200a6fa71.patch?full_index=1"
      sha256 "e284534df9ff14f49dad95a6745137c36c7a6335e896201c577d709794882e4c"
    end
    # Backport https://github.com/well-typed/ixset-typed/commit/1ee029539a77b0c7d854660707c9daa957d6fb11
    patch :DATA
  end

  def install
    # Workaround to use newer GHC
    (buildpath/"cabal.project.local").write "packages: . ixset-typed/"
    (buildpath/"ixset-typed").install resource("ixset-typed")

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell", "--constraint=aeson>=2.2", "--constraint=errors>=2"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG

    gpg = Formula["gnupg"].opt_bin/"gpg"
    begin
      system gpg, "--batch", "--gen-key", "batch.gpg"
      output = pipe_output("#{bin}/hokey lint", shell_output("#{gpg} --export Testing"), 0)
      assert_match "Testing <testing@foo.bar>", output
    ensure
      system "#{gpg}conf", "--kill", "gpg-agent"
    end
  end
end

__END__
diff --git a/ixset-typed.cabal b/ixset-typed.cabal
index 888d8a7..e42b86b 100644
--- a/ixset-typed.cabal
+++ b/ixset-typed.cabal
@@ -38,7 +38,7 @@ library
                      deepseq          >= 1.3 && < 2,
                      safecopy         >= 0.8 && < 0.11,
                      syb              >= 0.4 && < 1,
-                     template-haskell >= 2.8 && < 2.23
+                     template-haskell >= 2.8 && < 2.24
 
   hs-source-dirs:    src
   exposed-modules:
