require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.0.1.tgz"
  sha256 "cdbd5921cbef64c9c5f31428390305fd92b381c94bc8ae46c036462c8872c793"

  bottle do
    cellar :any_skip_relocation
    sha256 "b343fbe9055736148f542a3529e755562b624803e6f878dceba318de21766bf6" => :high_sierra
    sha256 "8153ee1287b22a3de47d1b532fef818c7e77ce30dbfc72c6a72551266f38bc70" => :sierra
    sha256 "67f66f94876ccc0bc0936f0306d072cf7d463b48b1e683eaadc8798a6ef3dab2" => :el_capitan
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
