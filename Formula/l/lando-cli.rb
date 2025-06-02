class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.24.3.tar.gz"
  sha256 "f40c9613fd6c6317bcbe335d24008b4fb07772a926d68e0d2b9de129781e5b6f"
  license "GPL-3.0-or-later"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "f488966079911f317384cc2893862868d21d481f5d1ee22fc51a9e17f8cae845"
    sha256                               arm64_sonoma:  "938521548f81a6e9229d66a1a853adc1326980b1d1554b10b02dd97e9e71ec31"
    sha256                               arm64_ventura: "20a446e841e400bb6c65d79f814107eed6ff2fca85b76e7553ecd50cd870ff0a"
    sha256                               sonoma:        "56f81b05f6be0c15b132b83c4782272b238e2654859ae40d6b06954506561364"
    sha256                               ventura:       "cb8bfcbaeb6290de377b60947d738579b12b0ae6acbc5c83fa2346636a83431d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d0289b9fd03eeef95270ad2a7f534d2f2e2b3c68c0749a79f2450a64d393662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d0289b9fd03eeef95270ad2a7f534d2f2e2b3c68c0749a79f2450a64d393662"
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
