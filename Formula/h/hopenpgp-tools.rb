class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.24/hopenpgp-tools-0.24.tar.gz"
  sha256 "717b919db0cc9971ea2bae152bf91f435cad7111a71d73360ae6b969f82484f3"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "09d52945d0c4de01ed27c1d65f623d025ba75ea9117c386c5747dd53e589f43c"
    sha256 cellar: :any, arm64_sequoia: "cb888abb13670ce4e5d02cf367265e14a21a1ee8ddfe1d4099b22473d58ae531"
    sha256 cellar: :any, arm64_sonoma:  "8112fe3d5d54342e7320c8e7a7d0f89260e5d5c9794aaafea0ba3f8b09eb47c1"
    sha256 cellar: :any, sonoma:        "4a89c9fbf044e0f232d381c6fdeba73bc8767da46d8dc7b784d573720d4a8a45"
    sha256 cellar: :any, arm64_linux:   "164902c2a3b352cb7504e10982e9580947b056c0f41ad3548846dced70f64b72"
    sha256 cellar: :any, x86_64_linux:  "176f910bbb32a9fedbd3347db8026d241fe9fc8a548b1b7a0fdcc458e70d2c2c"
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
