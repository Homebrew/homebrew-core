class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.9.1.tar.gz"
  sha256 "1758f0b9b1e81f8ae2fb3b79231c0020211ddd6cc715a38f30b0bfe1643bc733"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8263ebb55a8d512d3460b6fdd0f3f6c71b0ead67a2d86e9ff38ff8dbb34805cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "551df274b700bf7e8c84c23181378b8e21fa19f18014990a57484ec217a9895c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54abd511cbfb5406398a2d20e9dc27f8067daf60073f7f42d3c20519d3499f92"
    sha256 cellar: :any_skip_relocation, ventura:        "ce53ef7560d2b58263cedb34efac2d5df8a98fd5c07e6494c6dff40dc73f94c7"
    sha256 cellar: :any_skip_relocation, monterey:       "d06926025911bb74590fa40421fc6a5ded32bab793d4d6c4a8c14b04fa5875f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8788ceb4e3b3aa9d7585d0a3b940d3e839ac7a169fa77d3743e1057d996dc247"
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
