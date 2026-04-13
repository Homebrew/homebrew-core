class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  # TODO: Check if `ixset-typed` resource can be dropped
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.11/hopenpgp-tools-0.23.11.tar.gz"
  sha256 "2a056bd320caafe0f7ac3c95d56819f9fef02ddafe11b59802ea5a678d88a54f"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "6e1b1eccc7a834a587e44a3d72443034942527f06b6b871a9c44698c1cb21e58"
    sha256 cellar: :any,                 arm64_sequoia: "1cd126b1a338333e61bc6d5ff086511af4470c9a05764d5250417469a15669d4"
    sha256 cellar: :any,                 arm64_sonoma:  "089e8a318331d55e8dae0760ae8df764ca9e252c59dd1640f6f9b10ba56ce219"
    sha256 cellar: :any,                 sonoma:        "4556fef4e991d2e8dd07835f16b92f18d8c8151c1fb9043fa903a7ce0acc90c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10da1dd06cad90211489d231be6b4ddec80304bea1e57aa342c9c4cd2258fc91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a783536238023b381f195e111f0430f9d7931bea24fd9d31849675e00c29f639"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gnupg" => :test
  depends_on "gmp"
  depends_on "nettle"

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
