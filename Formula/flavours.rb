class Flavours < Formula
  desc "Easy to use base16 scheme manager that integrates with any workflow"
  homepage "https://github.com/Misterio77/flavours"
  url "https://github.com/Misterio77/flavours/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "48c7659031d399ff125a07b71419935946e0da8d3ef1817a9f89dda32c2dcac1"
  license "MIT"
  head "https://github.com/Misterio77/flavours.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c111b5a4b8d1202a90264539f524dac5bc9f3e870bb12730da491c1243d98c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9200bdc6a14abb08d74d76719b8e22bdd6fcb61199f681d21448c4db714bc34c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1115555c25d56152083fa2e769f6b284425edd7164cae47559707ae043e075f1"
    sha256 cellar: :any_skip_relocation, ventura:        "a43fd8c88dd0f6ca5969c2639403f92fbe366f5403654ac8d6a2d9bd216fb391"
    sha256 cellar: :any_skip_relocation, monterey:       "390e9e7c8829fc1f87b6a1ba982f2643609478fbdb3b5657a29195b8dd23330a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2690b1e9148bcdf1968668bede74d9aea501c22fd37252cbf00ccb564f740a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4862a79b1de2d1d7b9f4232bab8eb9671e339c21f172d19006a103d8ecd4d1c9"
  end

  depends_on "rust" => :build

  resource("homebrew-testdata") do
    url "https://assets2.razerzone.com/images/pnx.assets/618c0b65424070a1017a7168ea1b6337/razer-wallpapers-page-hero-mobile.jpg"
    sha256 "890f0d8fb6ec49ae3b35530a507e54281dd60e5ade5546d7f1d1817934759670"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource("homebrew-testdata").stage do
      cmd = "#{bin}/flavours generate --stdout dark razer-wallpapers-page-hero-mobile.jpg"
      expected = /scheme:\s"Generated"\n
        author:\s"Flavours"\n
        base00:\s"[0-9a-fA-F]{6}"\n
        base01:\s"[0-9a-fA-F]{6}"\n
        base02:\s"[0-9a-fA-F]{6}"\n
        base03:\s"[0-9a-fA-F]{6}"\n
        base04:\s"[0-9a-fA-F]{6}"\n
        base05:\s"[0-9a-fA-F]{6}"\n
        base06:\s"[0-9a-fA-F]{6}"\n
        base07:\s"[0-9a-fA-F]{6}"\n
        base08:\s"[0-9a-fA-F]{6}"\n
        base09:\s"[0-9a-fA-F]{6}"\n
        base0A:\s"[0-9a-fA-F]{6}"\n
        base0B:\s"[0-9a-fA-F]{6}"\n
        base0C:\s"[0-9a-fA-F]{6}"\n
        base0D:\s"[0-9a-fA-F]{6}"\n
        base0E:\s"[0-9a-fA-F]{6}"\n
        base0F:\s"[0-9a-fA-F]{6}"\n
      /x
      assert_match(expected, shell_output(cmd))
    end
  end
end
