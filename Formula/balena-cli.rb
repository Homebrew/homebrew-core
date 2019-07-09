require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.6.0.tgz"
  sha256 "f92c90b67170b697762bcdbd11848afd366191772a5e97d9d0c77abe3e0ef474"

  bottle do
    sha256 "0eb1a0d749dde225a053f9b4687088a86ce19be3a65bd8efc855366f8d1c04e0" => :mojave
    sha256 "0e906631f062d4880c421ad06175c265e78717cea6489eda3e94aeb974a73750" => :high_sierra
    sha256 "53b0b0529c4888bdd2bdeb1b8c092d5a3f49a026d73cc4464e3738a29a8f09b4" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
    assert_match "Logging in to balena-cloud.com", output
  end
end
