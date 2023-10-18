class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.9.3.tar.gz"
  sha256 "cc213ebd087bafd6f1faaaeb4cc1fae4da2a7e1c484ee9265cf113f6ce108376"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "738e99293907931fa3fd0a22084d2f9474ace9d5435bb019bf7638f3397022a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d70b7338fa940cd8bb69320351d2439fef7934b55e59a6d6a06d3a89b45b8699"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df806f8e7f783f7eba55030f6cd276f1d20e8d62e1fb44e6ff2e8d10133a27a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59bd6c10d1b730a1a08a0cb326cedaa0752b5dd3ac8027a30961f524e46f140f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1d9d98feafb0ace4033623e6345e8c3e2621bee75d7333ef16aae7a539f59e3"
    sha256 cellar: :any_skip_relocation, ventura:        "77a5de975ff122c908100c89422a07090d4da3b8f4e10b42c9c15c102789d347"
    sha256 cellar: :any_skip_relocation, monterey:       "100da0df53e8f6bb5a0d27328a004b317d59e307a13ee41aca8f2688fb1d615b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8053bddf715a147449eac24043a90b5e41833cde7d55edc3e21ee5a7d28a1331"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    # Release builds
    xcodebuild "-arch", Hardware::CPU.arch.to_s, "SYMROOT=build"
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
