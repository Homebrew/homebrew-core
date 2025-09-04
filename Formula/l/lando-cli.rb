class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.25.4.tar.gz"
  sha256 "b221461ef4f978e17d79eac89a2c130671e0749f84ab697780a48f8133bfd617"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "615c03d0a055c9013c76123987517ff1a82ba08c60f96c4252642071b66221b8"
    sha256                               arm64_sonoma:  "fab4d4571a136b3d2674a11411594ac40d30a6e0e038d133b8cc55b81dc4c185"
    sha256                               arm64_ventura: "0caebc9b408e94efb4af90d877a63ff5d933cbdae2c810db8a1f685862946686"
    sha256                               sonoma:        "da56988d0a6f708dbe77117e67fc90c7b2acae295e1e92ee8796e95ac6da2fa1"
    sha256                               ventura:       "9dd17ea27ccab104d1d9c2ed479a23f53f5575b3294ed899cbf55f90bcf0c8d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a3acf6913127cc3fdc9d9674336be11ccac484cc38cb2b24469ec4f5122058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09a3acf6913127cc3fdc9d9674336be11ccac484cc38cb2b24469ec4f5122058"
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
