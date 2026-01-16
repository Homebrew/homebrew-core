class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.26.2.tar.gz"
  sha256 "ae08ffd64fd558af43b4ce4cbb0996550ac3c1e7d89713544e7519922be2e2da"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1874c04bb99e224f34e6227389e226ec15c85a623c29dbc301343f13bce4107f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1874c04bb99e224f34e6227389e226ec15c85a623c29dbc301343f13bce4107f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1874c04bb99e224f34e6227389e226ec15c85a623c29dbc301343f13bce4107f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1874c04bb99e224f34e6227389e226ec15c85a623c29dbc301343f13bce4107f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048f67620bae8ac7f9d90a99cf9b74eb3915af1118f10b709bf1c69d47468b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "048f67620bae8ac7f9d90a99cf9b74eb3915af1118f10b709bf1c69d47468b3e"
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
