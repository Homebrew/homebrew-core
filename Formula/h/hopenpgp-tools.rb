class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  # TODO: Check if `ixset-typed` resource can be dropped
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.11/hopenpgp-tools-0.23.11.tar.gz"
  sha256 "2a056bd320caafe0f7ac3c95d56819f9fef02ddafe11b59802ea5a678d88a54f"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41b5917c6be661736f37f098bff90219a3c4f5cd87b396abf57389d219c1ccb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ea0bdb57778391700816112db32d245f0bb3ec0d8baeecca58764d3bfc9f54b"
    sha256 cellar: :any,                 arm64_ventura: "b83d81cff76f58a88f73c353b6807a82bb6186419bc525f7e90aaddea2e0c272"
    sha256 cellar: :any_skip_relocation, sonoma:        "81a7de6f22c94c9e6511f74ac6caab00902a992db025cc63503746ff7ddebe95"
    sha256 cellar: :any,                 ventura:       "8d3b9bf6403e965b552105bf02b1dd620325f5c37174d3c3959899eae71fe055"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b60d684c2fee4c0a2bf97fbc083340f7830183f7372edadb6e7a0fd9042843e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e51c27ef595c911cb7a2f208b6a5c5426e767240f3651e072b5af7bd6213156"
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
