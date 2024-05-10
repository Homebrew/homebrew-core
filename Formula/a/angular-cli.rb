require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.3.7.tgz"
  sha256 "66f7e72e93e656ad05438253ce743fafa0aebd5502eb2df3048362999aa059c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47a8c77e30c80d880fe59bde2e7f0be34725d9e6fbe9cac561af5fbe24c91a20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "129ea45259dfc6cfb733089dc7c87896ba44ad403ca4c1130283b86c7b790c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be050dc2735c67221a3e13e626dc8248f9f9f95dac28ef8435507493fc008836"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebb724e4c40e1296d44da7bb2ea38cf36b2e982897a2378d0da344b05fc8011d"
    sha256 cellar: :any_skip_relocation, ventura:        "7908e2360849b832ccb12664e683ab2ad1d6e2e3b06afc15243d678c8f08e95f"
    sha256 cellar: :any_skip_relocation, monterey:       "1aac99fb1de032cffd973961714bcb4188108b291e03c5cc42352780041cd2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d54bc470a5e859c9ce1ca5c854e9871610715580468b04368691dd8a06bc4e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
