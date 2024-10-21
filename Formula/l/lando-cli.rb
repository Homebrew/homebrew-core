class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/cli/archive/refs/tags/v3.22.3.tar.gz"
  sha256 "c8c621b8ee1b2e65aa8089d3eab3eacfefd4ae44a0e2cb4a856097b3604d6368"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f616f24b05a33f71c9965a07846a99b60eb514db44965f9f48e10c27dc3431f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f616f24b05a33f71c9965a07846a99b60eb514db44965f9f48e10c27dc3431f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f616f24b05a33f71c9965a07846a99b60eb514db44965f9f48e10c27dc3431f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "978e927afcc786146097a7fc80eb171d14062b8a78a308ca39d40e3d97e6411c"
    sha256 cellar: :any_skip_relocation, ventura:       "978e927afcc786146097a7fc80eb171d14062b8a78a308ca39d40e3d97e6411c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f616f24b05a33f71c9965a07846a99b60eb514db44965f9f48e10c27dc3431f0"
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
