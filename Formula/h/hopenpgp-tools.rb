class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.25.12/hopenpgp-tools-0.25.12.tar.gz"
  sha256 "525f41dc8defb2f20b3bb42f14ad26ec52051fae64c633553477495f6e20aa97"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "00fab11e11dd886f6a52f6aac4c8025c1b166518e8c3007b946cbaec069e36eb"
    sha256 cellar: :any, arm64_sequoia: "aefd9b53afd22d57928c3444e0b07e4953000b8f8f6d4fedfbfea0f35751238b"
    sha256 cellar: :any, arm64_sonoma:  "1c3511fcf35a8797810b0f913426b257e20c8ec7ad12181464f84a07841c684e"
    sha256 cellar: :any, arm64_linux:   "86807b50dda88993f7f783bdd7f778708654aff5e15d72638a2dfc6401f29819"
    sha256 cellar: :any, x86_64_linux:  "7b3ccbdff428293c60a034c48848ba4f9ba71c1cda9004fe41aa05ad0c7c349d"
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

  # TODO: remove resource after once haskell-nettle supports Nettle 4
  # https://github.com/stbuehler/haskell-nettle/issues/12
  resource "nettle" do
    url "https://hackage.haskell.org/package/nettle-0.3.1.1/nettle-0.3.1.1.tar.gz"
    sha256 "d548552c257ad0c64ddec7d4605456b0d0a672ca95eb6a3f761e19c6815acb42"

    # Apply Arch Linux patch until upstream supports Nettle 4
    patch do
      url "https://gitlab.archlinux.org/archlinux/packaging/packages/haskell-nettle/-/raw/aeed8e35267fb46cb17b137ecb12d2d34caefdb2/nettle-4.patch"
      sha256 "7de52534a84bff5f6893ac9267d268990ab2532d73016fa8dc31ef9169cc2c08"
      type :unofficial
    end
  end

  def install
    # Workaround to use newer GHC
    (buildpath/"cabal.project.local").write "packages: . vendor/*/*.cabal"
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
