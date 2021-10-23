require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.51.0.tgz"
  sha256 "c69f8f4b80015ee7d5abde71565db7db6f6a8d4ed5474464fa4f052234ea8a4a"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 catalina:    "1d68785ff12ddc57c8a6e93a0b83d3613e29ccf0ae8331dc8197a06bd1f47336"
    sha256 mojave:      "c2e8432c28bb7875f42d7815befa98001dbc72a65cffc121fb8dd6bf2d75290e"
    sha256 high_sierra: "0e670f3cc482565ddc1a166316407fab2fd008f12128a06f7f73c3bcf07a641d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
