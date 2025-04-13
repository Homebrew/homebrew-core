class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/refs/tags/1.10.2.tar.gz"
  sha256 "05684ef64ee1c9cc9f53e4da83aee6c72e4ba67e913af36e959e48e1e39fe74f"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b742b1edd9b7ea6de7197882e75c63530e68cc21434be76614e11aba76f335bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a0b0479359ba08144c0f56607a2097b04218051807cc0ae60bc73a60e46574f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5499c8160724eda14b5498f411971ec8c216f319c580a43a2a00d7f0fe9ab687"
    sha256 cellar: :any_skip_relocation, sonoma:        "87d2ad8690168f33d50b18c00022f96cddc5d1de38c4ecb65ea0d3a093d91f6e"
    sha256 cellar: :any_skip_relocation, ventura:       "9eb66895d46bdd9c55ad13c23c4a53ceecf4ad93e7cf766f7dd786765dbd7fb7"
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
