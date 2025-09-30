class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  # TODO: Check if `ixset-typed` resource can be dropped
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.11/hopenpgp-tools-0.23.11.tar.gz"
  sha256 "2a056bd320caafe0f7ac3c95d56819f9fef02ddafe11b59802ea5a678d88a54f"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "47af189fdfbcc2b7ab692127e4352f6eb5bdc5573f64918b6ac7abb13215079e"
    sha256 cellar: :any,                 arm64_sequoia: "0abaf700294d6bcc8ec68b211e3705115ffc75d7de6ca66003c327f65fead083"
    sha256 cellar: :any,                 arm64_sonoma:  "cc66eb8cd7c9041526829cf42d7165911a5133efba6a15bba72c4ed62842a695"
    sha256 cellar: :any,                 arm64_ventura: "168109c37c5ddce6e572cb5eee589a63a1e8e3cc7aad18f2f4723614bfc2b13f"
    sha256 cellar: :any,                 sonoma:        "b6f9cc17771af94ce8162032631085e983baccf90e6b5d49b3726da81e7713fd"
    sha256 cellar: :any,                 ventura:       "e3097679dde5250ab36974a7ec5adc805dbbb7bf7baee726455616287dd8af3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50fd1b8792416bb2dbce9353490738993b00a89e30a064b8f39dc08e6ab940c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c20f007e3cebed6ad6dc14cbaf3db6f1fe05dc0a98cb6a491e6174a531594a2a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gnupg" => :test
  depends_on "gmp"
  depends_on "nettle"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

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

    # Workaround to build with GHC 9.10. `data-functor-logistic` is a
    # dependency of `rank2classes` which uses the same workaround.
    # Ref: https://github.com/blamario/grampa/blob/master/cabal.project#L6
    args = ["--allow-newer=data-functor-logistic:base"]

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
