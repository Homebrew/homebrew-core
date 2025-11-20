class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/refs/tags/1.11.0.tar.gz"
  sha256 "e719cf5342f907cb06811c39c7a6ca087e584d08d1185e2eded9953dd218d918"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d551c02cfc196db2d8e930c9c58c6aa6c397ad2cddd4990a6b368db465b3a467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "628f12ae25a466c35328cd1578c6428ece0942416f07e5df663919edf68d1c6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "807ae024d63682ce4573ea99c27172c606f370b96a21cff8a4626ba3aee8018b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d06011bc7b3936bbcb44f2f4ab49b4749000af5c325d29afd85090148c8481ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "390e82e1ed87e9d5882ae863c68f7cdc2baad2cde72f862fc5efca511a4743c9"
    sha256 cellar: :any_skip_relocation, ventura:       "46815e7636eaca21c421825509183052781caf166ba76957eb13aa74c6e8fc5d"
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
    bin.install "scripts/arc-cli"
  end

  test do
    system bin/"chrome-cli", "version"
  end
end
