require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.17.0.tgz"
  sha256 "93bc5631e265529930833d9430b6afd7da78125c1425ddb3bacd33d60c96db2c"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "b4a7ed04436993e445aad169f8d39cf4b39f5444336762fb4593e82dd3770c84" => :catalina
    sha256 "88741358dfae2cfc7443be374158683c9cc150adc3e591f5bd1b1e1d0e10f0f7" => :mojave
    sha256 "5e56a072bb25485e08066d3f2c1d5ad6556c870af79b45fb5d8e7c4fb5ee47e2" => :high_sierra
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
