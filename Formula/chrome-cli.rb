class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.7.1.tar.gz"
  sha256 "27ee5ab9a9d60fbd829f069074fe592f2aafd129df0df4aedbbc12b8df11ac32"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2811e816a8994328fe3f6ea28935656ba0ce87de8e5a5e38a2a0c209d78fc279"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "835b7a9995ff61f7623ded6ce772d5ae712651aa690102c79afa0f989a6f5285"
    sha256 cellar: :any_skip_relocation, monterey:       "04c69afc601992c0415706c92b0a07774be82b4f5f34a4d2a9d6a4c405de78c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ce2275e0b6f7d189ee64884027807b6dd9305b89e4c382dcf6da4425bea2482"
    sha256 cellar: :any_skip_relocation, catalina:       "8f263e2bc13457f68605d83e6aaf0dd26eda374e8342c955d97c497bd6b53a4b"
    sha256 cellar: :any_skip_relocation, mojave:         "0ab4cf9ab507b5403c98493840d126a3d0062d9a19f982c8ee58b0d3a73748b3"
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
