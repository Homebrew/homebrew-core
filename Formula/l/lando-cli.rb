class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.26.3.tar.gz"
  sha256 "c61458af0ec84c39db41fb82ce379bd6838148940454dae27c2d0869cb764904"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f189eaf3c5402615f94218285300d16bc11384e6975c5bced2910391ea047fb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f189eaf3c5402615f94218285300d16bc11384e6975c5bced2910391ea047fb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f189eaf3c5402615f94218285300d16bc11384e6975c5bced2910391ea047fb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f189eaf3c5402615f94218285300d16bc11384e6975c5bced2910391ea047fb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a129adb8f4bdf6ace7421657bd952242126270411efb6785ecec20d9a77e99e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a129adb8f4bdf6ace7421657bd952242126270411efb6785ecec20d9a77e99e2"
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
