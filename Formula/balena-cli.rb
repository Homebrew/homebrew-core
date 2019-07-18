require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.7.1.tgz"
  sha256 "a91a238ed69afba40ab81f43dd5e41737a5fb39f249ae5ac09e4223df93f2a72"

  bottle do
    sha256 "4f8c5be6354cd25b306b2282458f0bbe29bcc8c317628f25a23fb995782fb164" => :mojave
    sha256 "548714f8eb126a90069e655a4c184784ba0d415285d59999d1abd45c6e0c4880" => :high_sierra
    sha256 "53f58adfe03e70e91c87930f97d6f1e6d3d8d5a67822187cf6182910d03d7a27" => :sierra
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
