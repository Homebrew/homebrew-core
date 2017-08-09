require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.10.tgz"
  sha256 "0ad0cfd7d827bca4589a864787c1fb103a41aa71699ba5de0d01ddd86f89d278"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0365059200d8d25e037d70bf1d40fe8a95185a4e4e25e7c183e6eec6d6dbafb1" => :sierra
    sha256 "a64da507fd31df86235552a8aea22e5e652292261e49ab1be94aeca846a00029" => :el_capitan
    sha256 "64df1ee30c0bec07800a0ab7d148880fd866b5876264e3ab57d3084bf4936849" => :yosemite
  end

  depends_on "node"

  def install
    inreplace "bin/run.js", "npm update -g heroku-cli", "brew upgrade heroku"
    inreplace "bin/run", "node \"$DIR/run.js\"",
                         "#{Formula["node"].opt_bin}/node \"$DIR/run.js\""
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
