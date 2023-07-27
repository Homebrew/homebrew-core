class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.9.3.tar.gz"
  sha256 "cc213ebd087bafd6f1faaaeb4cc1fae4da2a7e1c484ee9265cf113f6ce108376"
  license "MIT"
  head "https://github.com/prasmussen/chrome-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8422f7b43bf55f8347cd022673713948fe720f78372cd8ceace8f839cc3b6e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae09bf61be5ff851a68b0d3fd458db3e299c071b44c1774cf37cfcbe5fed117f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36fe403ec9ee419b4ea90a2511f82d4a6032654bb74896d35932c31e23c45ab3"
    sha256 cellar: :any_skip_relocation, ventura:        "1cc8a4c30dfd88eacb8993defb1adde1ad7bdc519d765fea8cab3ae4855e57fe"
    sha256 cellar: :any_skip_relocation, monterey:       "77f2aa7ccec6346437d6ea448528dafaae702e1aa32ad1f104ef44b52c169f10"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffea5cf4f95619b8cec885184593f96883df14bfad8734d26473cce8e30ef07f"
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
