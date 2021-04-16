require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.15.1.tgz"
  sha256 "1267ea274c9a30c9930016979986100d3b8411bc62133d9a5f57f7740dee2f44"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "540752b708caa92c8ba0000d988702e63e0e2d47a187acaa05368f75924145ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "4972cd6fd41961b3e7ae47491cf547bf245071950fddffbb2f6389a8c15c9de3"
    sha256 cellar: :any_skip_relocation, catalina:      "dfbde3dd5cc42200caa86c60322985c460c8ba075080da1eabd0b0f25a883e32"
    sha256 cellar: :any_skip_relocation, mojave:        "aa07995f70f082dcc662468c7dfbf7f305a832cb6618061e8fccae08927b9c1c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
