class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/cli/archive/refs/tags/v3.22.1.tar.gz"
  sha256 "41cd4e03a783c2fb5f06c5f8f80f00abce0e52094cc57a2b76cdf380c2bfbd0f"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "258f5ca707b7370ab6f0d4bf05eacac97d35c6e5528b4dd72f152cf17585000b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "258f5ca707b7370ab6f0d4bf05eacac97d35c6e5528b4dd72f152cf17585000b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "258f5ca707b7370ab6f0d4bf05eacac97d35c6e5528b4dd72f152cf17585000b"
    sha256 cellar: :any_skip_relocation, sonoma:        "26b24bb34fb5b44a611dc1a34dfd9b41c267c7f6001485ac2aeac09df4c5afc5"
    sha256 cellar: :any_skip_relocation, ventura:       "26b24bb34fb5b44a611dc1a34dfd9b41c267c7f6001485ac2aeac09df4c5afc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "258f5ca707b7370ab6f0d4bf05eacac97d35c6e5528b4dd72f152cf17585000b"
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
