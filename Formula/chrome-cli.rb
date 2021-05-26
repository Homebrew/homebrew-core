class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.7.1.tar.gz"
  sha256 "27ee5ab9a9d60fbd829f069074fe592f2aafd129df0df4aedbbc12b8df11ac32"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d184bf01ce8451e1cff13435c7928c73f00815182ce4692a9e117ebb4c265e8e"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd36420b3b200890cd6e3acd0ad469750911197f02891301b0b1313da282e50e"
    sha256 cellar: :any_skip_relocation, catalina:      "dcbd7ddb868c433f456921994be98e77d14bad4b51f3b1d5940def7bd845e7f5"
    sha256 cellar: :any_skip_relocation, mojave:        "45226a0320842d8e3d717ffdf6e8828b9d1b5f52609757670f4d542fd722ee68"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b34f789eefdbb6312b05e4e55a71e9deaf889fe740e2d976cdf4279a0d74dd36"
    sha256 cellar: :any_skip_relocation, sierra:        "31abf08f56dc906ec882cb4d7dc167424177c8849b8de8ecb71098afb249fc84"
    sha256 cellar: :any_skip_relocation, el_capitan:    "e1d04616371d4c7147f884886d2e61df3bdea48c388dc50a684434f89b417792"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    # Release builds
    xcodebuild "SYMROOT=build"
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
