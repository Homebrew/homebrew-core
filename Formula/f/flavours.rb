class Flavours < Formula
  desc "Easy to use base16 scheme manager that integrates with any workflow"
  homepage "https://github.com/Misterio77/flavours"
  url "https://github.com/Misterio77/flavours/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "207002728cc270d92f4cd437384925e767c611d30520ec8a29816dfe600d7f61"
  license "MIT"
  head "https://github.com/Misterio77/flavours.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "efc1a63ebb981bccfce1b2653c2725489034a078dc51c99efe90daece4fcf77f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "391fe5d4aea3816013cb4826e96fbfb8cc5c2d2c9e3cf00c43abbdc733e114aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cd11ff2bc2a0b8eba4021394e80982f562b389609b0e532a78b5c115c9933a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76fb0fc700fb8ca4b0782a6fe3c5929e41885d8fcedd8733801b15201efd37eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95b55c5ca8366840c9f3aeed5d525b200fe2ecb8e590dbba957034c556a531f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31327342d9aa50edbfbb67c99ab56ccb2f04eb48f2cf25f1f75e32787b335dcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2fff8e91c6cbd2a3706403adc08c867a386323f48503d40781ee42b72116ee7"
    sha256 cellar: :any_skip_relocation, ventura:        "cf8bb2e1d3c20d057a79a8dca7c8249e93e63ed04178b910740b07767df38829"
    sha256 cellar: :any_skip_relocation, monterey:       "963a8dbb9b4cfdfda2a65bdb5a16df394bab78f96bf2e707b1e5cbd11dd575e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c976365af9c8ce579298e8232dda3605ad0a20116276dfda4084cd413e599b0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c5cf394608a4a2d38ad428f8b5510a64d370aae95411629cb9758378ad744fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35fe79bebc20bfc9453e7b313a5ffa5fc5040de4b7c896e98dcba4011425ade4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "homebrew-testdata" do
      url "https://assets2.razerzone.com/images/pnx.assets/618c0b65424070a1017a7168ea1b6337/razer-wallpapers-page-hero-mobile.jpg"
      sha256 "890f0d8fb6ec49ae3b35530a507e54281dd60e5ade5546d7f1d1817934759670"
    end

    resource("homebrew-testdata").stage do
      cmd = "#{bin}/flavours generate --stdout dark razer-wallpapers-page-hero-mobile.jpg"
      expected = /---\n
        scheme:\sGenerated\n
        author:\sFlavours\n
        base00:\s"[0-9a-fA-F]{6}"\n
        base01:\s[0-9a-fA-F]{6}\n
        base02:\s[0-9a-fA-F]{6}\n
        base03:\s[0-9a-fA-F]{6}\n
        base04:\s[0-9a-fA-F]{6}\n
        base05:\s[0-9a-fA-F]{6}\n
        base06:\s[0-9a-fA-F]{6}\n
        base07:\s[0-9a-fA-F]{6}\n
        base08:\s[0-9a-fA-F]{6}\n
        base09:\s[0-9a-fA-F]{6}\n
        base0A:\s[0-9a-fA-F]{6}\n
        base0B:\s[0-9a-fA-F]{6}\n
        base0C:\s[0-9a-fA-F]{6}\n
        base0D:\s[0-9a-fA-F]{6}\n
        base0E:\s[0-9a-fA-F]{6}\n
        base0F:\s[0-9a-fA-F]{6}\n
      /x
      assert_match(expected, shell_output(cmd))
    end
  end
end
