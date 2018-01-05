require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.7.tgz"
  sha256 "86d30895fc0a54a8abd0abb1213c1224a6c6b504cbc3b2e4aaa3004ee1f278f8"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "484d4d84763471eb05a2082e21ee385402aa510f5bffff752a1824b8f956b56a" => :high_sierra
    sha256 "9e0d63c1a4d3a630bc7ec74dff226500a2d262e0abdbd6c967c1ec465d3a78d7" => :sierra
    sha256 "6ae7b719ecba042924ef29cb6a243aa24b3590067ecf0fdcfaa3e064163b8451" => :el_capitan
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
