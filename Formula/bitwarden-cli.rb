require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.18.0.tgz"
  sha256 "286d0ecc294c6ab1986e44469da82863027a58bc0ba1c34f0053f579d80caab5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "313a4cb82859f4b4bb84878af56318cfb5a5b83b4ceddb6ba6b1ed257f266268"
    sha256 cellar: :any_skip_relocation, big_sur:       "426dece72db63b5ebcc08dc6c646aee2d4875e8c8243a85b9ab80886fc06bdf6"
    sha256 cellar: :any_skip_relocation, catalina:      "426dece72db63b5ebcc08dc6c646aee2d4875e8c8243a85b9ab80886fc06bdf6"
    sha256 cellar: :any_skip_relocation, mojave:        "426dece72db63b5ebcc08dc6c646aee2d4875e8c8243a85b9ab80886fc06bdf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "313a4cb82859f4b4bb84878af56318cfb5a5b83b4ceddb6ba6b1ed257f266268"
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
