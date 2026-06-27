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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "108ae5759320ebe4feacea758cb57d45d663e855f2ac378d99ea25530dfa933d"
    sha256 cellar: :any, arm64_sequoia: "c82c7ddb72e6dbacdca99f7003209a7c0c88680c88b667b9732293eb2941650e"
    sha256 cellar: :any, arm64_sonoma:  "0d7733b2849d961e358155bf7d150dfb26bc5df0463d93feda52ec5d46e67d84"
    sha256 cellar: :any, sonoma:        "11e58321ad99d82f7769b6a18cd3a43a29aaa1ff77fe65ffb25bdbc52cf9ce18"
    sha256 cellar: :any, arm64_linux:   "70830db8a70bcfd675ae3d31aa51849a20c254314c492315c15e972c9d2163b4"
    sha256 cellar: :any, x86_64_linux:  "a5b2216d0ed1cfc6946f2685c9807f56c7ae954a721d11b3c74ca90ee5e1d0f7"
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

  # TODO: remove resource after once haskell-nettle supports Nettle 4
  # https://github.com/stbuehler/haskell-nettle/issues/12
  resource "nettle" do
    url "https://hackage.haskell.org/package/nettle-0.3.1.1/nettle-0.3.1.1.tar.gz"
    sha256 "d548552c257ad0c64ddec7d4605456b0d0a672ca95eb6a3f761e19c6815acb42"

    # Apply Arch Linux patch until upstream supports Nettle 4
    patch do
      url "https://gitlab.archlinux.org/archlinux/packaging/packages/haskell-nettle/-/raw/aeed8e35267fb46cb17b137ecb12d2d34caefdb2/nettle-4.patch"
      sha256 "7de52534a84bff5f6893ac9267d268990ab2532d73016fa8dc31ef9169cc2c08"
    end
  end

  def install
    # Workaround to use newer GHC
    (buildpath/"cabal.project.local").write "packages: . vendor/*/*.cabal"
    (buildpath/"vendor/ixset-typed").install resource("ixset-typed")
    (buildpath/"vendor/nettle").install resource("nettle")

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

    gpg = formula_opt_bin("gnupg")/"gpg"
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
