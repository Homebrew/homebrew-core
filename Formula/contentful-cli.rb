require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.30.tgz"
  sha256 "f6d1ae178f74b302b603263b59adec0056f681a40ef5a7df663e9884170e9e2a"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c217a123bc792f41eee26aeea744469e0fe308c79e6a8ff98f573139778869ed" => :catalina
    sha256 "8c96dcaf60fb6abed9d9e2bc49fb2c1632e275e38258ed9e727e67c3b2cd7382" => :mojave
    sha256 "f9fb135cb48f20c8b64824ce55cef17718a9f15b1268d0ba56ff5f882e863ccc" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
