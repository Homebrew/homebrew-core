class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.9.0.tar.gz"
  sha256 "72592be318c267608845e826fb2f7a734f6ba2b113c79681ec47adb2f8370179"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9cad7a2ea2a83eedee95fe614d0aa403d4a68d43506291e2bc995a696a39da8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b40f80e3df682fd5aba11db1309c804f6aa1c0c2f5ef6968dc8a02f159c93896"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4648829faea6d5c7d785457ab37743c60ca13cf2cab00931bee898c09b291061"
    sha256 cellar: :any_skip_relocation, ventura:        "9c596ba1446b40a6f4b0cc54ac632b1136296bb3387eefc05547ea98ecbcbedc"
    sha256 cellar: :any_skip_relocation, monterey:       "80285d8813788bb56dfba93a138ee2b005c17dbf6963ad27c2da12f52053817a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd136a38941c85cf7159438f9a7f3a13baef83c9d2e43c79ab01c0d237de4341"
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
    bin.install "scripts/edge-cli"
  end

  test do
    system "#{bin}/chrome-cli", "version"
  end
end
