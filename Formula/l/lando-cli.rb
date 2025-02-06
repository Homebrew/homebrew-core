class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.23.26.tar.gz"
  sha256 "27d8d8e1a0f8aea119148860416374939db9621fd096e8c930ce2d8dfd03f6ba"
  license "GPL-3.0-or-later"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "a24c635fbc5ec79572cfc77e57efab88e54f7d27a35e528839f4209f8d13619c"
    sha256                               arm64_sonoma:  "b4d5bbfda84eb1396a03abb909c450b35cbf8c287c17b240187fc4d79abe4554"
    sha256                               arm64_ventura: "8034e72bf33c21bb9c15b89cfb83841f7c72f72adb88dcfc5236f58f8de7256b"
    sha256                               sonoma:        "529395ef2e3f82e59836ab7c9e1c37c951ab36d15427001d33b1abf2bb9dd5ee"
    sha256                               ventura:       "2d261c0b85e0802e16c085e7a6c2c88264ffc94e018eed1aba1342c10f238c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba8d557dc8afaeca0c1e7481d0dffaf0df4191bf4a28934c736ed4e88598ecfa"
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
