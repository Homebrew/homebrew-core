require "language/node"

class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-5.0.2.tgz"
  sha256 "37a938477b8126ff9ead74064eeffbf7cedfe497dbf8f0b6390b50fb7a25ab5f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a68c10f71dea8705a4d8f9842bcd5db91fb9c60a0f8ac2dc80de6d8a69a43202"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a68c10f71dea8705a4d8f9842bcd5db91fb9c60a0f8ac2dc80de6d8a69a43202"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a68c10f71dea8705a4d8f9842bcd5db91fb9c60a0f8ac2dc80de6d8a69a43202"
    sha256 cellar: :any_skip_relocation, sonoma:         "776ff9cb929dceb24c39489c75d63e5b358468c986ebc7b47319648cc5a974a3"
    sha256 cellar: :any_skip_relocation, ventura:        "776ff9cb929dceb24c39489c75d63e5b358468c986ebc7b47319648cc5a974a3"
    sha256 cellar: :any_skip_relocation, monterey:       "776ff9cb929dceb24c39489c75d63e5b358468c986ebc7b47319648cc5a974a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a68c10f71dea8705a4d8f9842bcd5db91fb9c60a0f8ac2dc80de6d8a69a43202"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
