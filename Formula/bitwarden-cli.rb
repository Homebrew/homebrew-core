require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.14.0.tgz"
  sha256 "6f0d5e7c78afd7aa5c1b2f393638705700f2792101eebe57eac8bd30c94c9756"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76456ab9cc5aa55791cc6480d771b23370a3ed3ac038efd7841cc3535ecbc1c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "d35e2f8abba1c08879ef4f756643b005dc13ced957cabb542ae9fe8ca72eb71c"
    sha256 cellar: :any_skip_relocation, catalina:      "7be0a5239e74b4a754730ca1baecb6e2666a7a2c2883ffc61b368989e50dbb4d"
    sha256 cellar: :any_skip_relocation, mojave:        "a55e52d3c9c4fe1fba871182575dceb6b7a415cedeea192062d556b07b61483f"
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
