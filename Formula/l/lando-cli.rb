class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.23.25.tar.gz"
  sha256 "da8a6f00d533d15efc6ead9678f21f8fb6652c188cc7d07390af9c9377d38b99"
  license "GPL-3.0-or-later"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "88d841ff6000d7a6e78fb349c9d70fdf85b7b52d9570a717628e5d8d8c619abf"
    sha256                               arm64_sonoma:  "778e266b4d7d5ac3c9fb41ea92d614b10a9bd0c1f4d25f243064bfa7976ea8fa"
    sha256                               arm64_ventura: "ac1eb6b0a7b3d479c69ae974e67a70d939089b732d655e73e356e0c12ab19cee"
    sha256                               sonoma:        "8aa55ea4894e1c10ab8fca78e848839f8d04c7c80e1f799d55f87ac5c09581eb"
    sha256                               ventura:       "4a1381665e6321e3dd03fda1c3516a933ba789ea3e064693f0fe0da0c4d5fb63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3633e7eb64145371532ec7b666ba5c9cbf04d9c65437f9ea70184f742260bc"
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
