require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.26.0.tgz"
  sha256 "62bdf53a6113d06cf65d476ce03ac85a9d0ee5af273087e45b8c2ee1e7c70c72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a64e6da06ed3a1c0f34cca44e25326cd7e6420764feb751b121d6d30453a641d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8175b37b15077fe73f6ab5f321d835fc6b1c6c2aa4c3faf0945211ec05a68369"
    sha256 cellar: :any_skip_relocation, monterey:       "196cc241cabe2c14328da000d6220e72b6d2a89cabd31c0bc68a710d73ff17ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "e07ccf3d1b813daa7c3f891a8e92aec6073fa76e64faefb2b03cb81b5daa63a4"
    sha256 cellar: :any_skip_relocation, catalina:       "947c0f10f91f82ac3824b915c9c08982d6ffb734e33de9f4d2a8af3da9908478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63d923267b0892662cdcd435c65603aea6eeff21196ae4f7a064d4bc8511522f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
