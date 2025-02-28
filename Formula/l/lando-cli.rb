class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "7c730924e3b41ca8dbc2e4350d3ee57511a1809f276d4ae84283fb59c58146c2"
  license "GPL-3.0-or-later"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "102619f90a266e698ff6f0d7b62baebd05fd9f6d54e76908f245ec18f3748bc3"
    sha256                               arm64_sonoma:  "99c8c7d28982afcb26802ff121ae431c120932d20d6f49074411407ebf4abc28"
    sha256                               arm64_ventura: "a01c91ae729f7ac1d1d411ad3f77832713c1a237d0f6500d254d761c8dbce66c"
    sha256                               sonoma:        "a18c0d8f507774295521503be259d30bb06fcc1c9bc2c9d3ac7c7f847196b883"
    sha256                               ventura:       "4b2d6e09495d666f08e63fceb2ab7693048b45d5fc5929ecebd944cb2ccf4a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df0b922de211072f4ea6e23ffba885da2a87199a2fdbc10f20b4fa150f16fb0"
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
