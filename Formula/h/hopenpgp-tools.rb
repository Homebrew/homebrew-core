class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  # TODO: Check if `ixset-typed` resource can be dropped
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.10/hopenpgp-tools-0.23.10.tar.gz"
  sha256 "5a89eab24143ed212b6d91e0df9cc00d9b0ebd3ccf7a0b65b4f29768c4044e29"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "454c7f1db4aa75a3b8645cbfdcd55b0c3a1c48faefe3f4ea5b9d7fddd862544d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842b69bcbeacdb7a8debb729a1165d7ad16bc62e9938b20fbf98a136cf02a422"
    sha256 cellar: :any,                 arm64_ventura: "8d996b1a36cd2565b0cc00dfde4a820220d905acbba85d41d0620888a11da727"
    sha256 cellar: :any_skip_relocation, sonoma:        "824baa8add32bd98dda8c7a6358bbe789d1ee535c1ccc947eecc68e337544799"
    sha256 cellar: :any,                 ventura:       "36be45e7e532005ef1c836aee093666fdddc2cae27855146c13ac0dbc0b37ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "522e51de7cf2aec5233d680e28502cc2f76deb153f5130a9a7ef89df87471f7e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pkgconf" => :build
  depends_on "gnupg" => :test
  depends_on "nettle"

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
