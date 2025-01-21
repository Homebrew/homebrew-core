class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/refs/tags/1.10.0.tar.gz"
  sha256 "d8ff25fb608ca4145d4af688e999ea106128e75b95fb1edc6861499133e9bb8c"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2210e8b8154ae8a886bf9917bd25f60a06e51a30c136e1a396d91541220bb6ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dbfcf2110ce0c98549762695f3f1ea7a9d4d2b6858151607cadf5ed13bc981b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6423c14b6452d94b9f79ebcc3a71c8e0b6158c12810f57c9efc1be57d1ab2169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63ae694a49b249cfeca26389f5c201417ea4b7d56c0db46669856993a67f5702"
    sha256 cellar: :any_skip_relocation, sonoma:         "d34831217ca47d2f91e19643307e7dba5c8b31a136380ceabc469ce8f13ce730"
    sha256 cellar: :any_skip_relocation, ventura:        "a5094b212f9f4d9edc5af49a0df72a8046605ab450b7c72d9aa13fd593305880"
    sha256 cellar: :any_skip_relocation, monterey:       "bd67692c870bc96c11800fdddeac4db57fbe6abc5bc01e2d1e82464320f8eaa8"
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
