require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.7.1.tgz"
  sha256 "a91a238ed69afba40ab81f43dd5e41737a5fb39f249ae5ac09e4223df93f2a72"

  bottle do
    sha256 "89a02464c01ac802332d311652d5cc775b9a676389fd08f52e0ee5b498fcd9ad" => :mojave
    sha256 "b843e98070e3bad16a229c38700be501f09597530832fee45bd197e49c2929cd" => :high_sierra
    sha256 "e148fbc3777006ae7aa4aa7fc566143df31097a6ddaa288f1ae7b6e2672768d9" => :sierra
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
