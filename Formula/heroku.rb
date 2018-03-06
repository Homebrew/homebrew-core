require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.30.tgz"
  sha256 "8e05ef5d29df53bcd0b2835450d83eb6718d09c5b42807c4d5d12c1848dad5ff"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fc75052a876d53f29517f53af18e3f8c5072b8824d9cb4fc78b7fbef8350f85" => :high_sierra
    sha256 "fc64b52e8e881c7c4f8a79a16bd1ef3b529ce9f39e257e4120a9f54debe6869a" => :sierra
    sha256 "32f68ad6aa33e95d41503be1fa7ef9e34824511eff428d44f73202d3ae5ef4aa" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run" do |s|
      s.gsub! "npm update -g heroku-cli", "brew upgrade heroku"
      s.gsub! "#!/usr/bin/env node", "#!#{Formula["node"].opt_bin}/node"
    end
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
