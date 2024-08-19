class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/cli/archive/refs/tags/v3.21.2.tar.gz"
  sha256 "2b930fa5c7cbe50396d147d3cf51f382e8a7312607f9dcefc04a4ad1399f4a46"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9d8a04967096e248ac76dff7fb285bf51ab9315cb8ff0d64e59d2c7140091a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9d8a04967096e248ac76dff7fb285bf51ab9315cb8ff0d64e59d2c7140091a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9d8a04967096e248ac76dff7fb285bf51ab9315cb8ff0d64e59d2c7140091a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "532c6a084e1bef8b5ced5974e881305d28d2a97ee1f888da5d2af5bc9a551f43"
    sha256 cellar: :any_skip_relocation, ventura:        "532c6a084e1bef8b5ced5974e881305d28d2a97ee1f888da5d2af5bc9a551f43"
    sha256 cellar: :any_skip_relocation, monterey:       "532c6a084e1bef8b5ced5974e881305d28d2a97ee1f888da5d2af5bc9a551f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9d8a04967096e248ac76dff7fb285bf51ab9315cb8ff0d64e59d2c7140091a8"
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
