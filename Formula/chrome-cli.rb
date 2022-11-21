class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.8.0.tar.gz"
  sha256 "fc57ce8a5a55220e88ecb3a452c81b8af94f832c06d4f11d13914dba061776e3"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2906090cfc853b40887321a0b55810146793f14f782ffa613569b261d8cd5098"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf65772593e86be9a02761d2ec17ffdf685c4f3eb28a01cdcd7a7cc18e39d54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df1f09538d913e62a7be6529e3936bee96b9ceac29e04b48b320ec2fc426be07"
    sha256 cellar: :any_skip_relocation, ventura:        "2762923b16b57cd06c6df2fa405f2f2088790c2c1bb27f0a027ff6b77906a892"
    sha256 cellar: :any_skip_relocation, monterey:       "8a54bfafacf5fa0bc13824a28c7994d17ab7271fd90c40defb8eb3440ac22af3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a63860da780f58237ccae8deb63425d54f827093004d0a8fbbb05191a8e5b5b0"
    sha256 cellar: :any_skip_relocation, catalina:       "7e3ee262df867a7f9f928b4b2e5e8f9eab064bd0833008e9be672352a85eb37f"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    # Release builds
    xcodebuild "-arch", Hardware::CPU.arch, "SYMROOT=build"
    bin.install "build/Release/chrome-cli"

    # Install wrapper scripts for chrome compatible browsers
    bin.install "scripts/chrome-canary-cli"
    bin.install "scripts/chromium-cli"
    bin.install "scripts/brave-cli"
    bin.install "scripts/vivaldi-cli"
  end

  test do
    system "#{bin}/chrome-cli", "version"
  end
end
