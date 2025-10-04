class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.25.6.tar.gz"
  sha256 "53218d29380ff2792a24313cd41141d144115e5ea76c510816da3bd03cc49f59"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "61048e58e98a2ae3779ea1c542ab3a55b0e0ba100a4c65c3b9de7cd295a4766b"
    sha256                               arm64_sequoia: "5b8a7373b73c3255aff9980b233507de7e2a67b10eefc72274b7cdeaffaa6319"
    sha256                               arm64_sonoma:  "61ff07d39da42fd7ce93d702d87cea64cff482e7bf08b690c15480d71cdadd01"
    sha256                               sonoma:        "328dd2107340bcff7166b56d23e1b21cf0a3c2797044085670779a42d74d2d74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3103b37484e639a55d939648ecf68881f4793f2ad487017eb2f2f7e8147234d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3103b37484e639a55d939648ecf68881f4793f2ad487017eb2f2f7e8147234d3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", LANDO_CHANNEL: "none"
  end

  def caveats
    <<~EOS
      To complete the installation:
        lando setup
    EOS
  end

  test do
    assert_match "none", shell_output("#{bin}/lando config --path channel")
    assert_match "127.0.0.1", shell_output("#{bin}/lando config --path proxyIp")
  end
end
