class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.26.9.tar.gz"
  sha256 "0e552b37ed2a38e6cc1467ed170bad9781b2eba4302545661dc00e6981a2456c"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48514fa0c92ef770de24b85dc19dd2364f1a54fa8a3f4ae4675998ecc1ec934a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48514fa0c92ef770de24b85dc19dd2364f1a54fa8a3f4ae4675998ecc1ec934a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48514fa0c92ef770de24b85dc19dd2364f1a54fa8a3f4ae4675998ecc1ec934a"
    sha256 cellar: :any_skip_relocation, sonoma:        "48514fa0c92ef770de24b85dc19dd2364f1a54fa8a3f4ae4675998ecc1ec934a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f63020fe76bb1e48d488562506c947b90e3251b4100c6fcc1cda59754a3c7d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f63020fe76bb1e48d488562506c947b90e3251b4100c6fcc1cda59754a3c7d4c"
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
