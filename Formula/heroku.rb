require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.17.tgz"
  sha256 "e6b80a63b6572daf1388e3a2e381bd0a282869a1660797c8108439e44e9a1f24"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4dc6bc49b46957b2b721bac31a655e3dfc4c04908d5ff36d3ae13dca18e127f5" => :sierra
    sha256 "e9af53bbde315144547dd0c1138a06e77a9a22c8c5147cf382cd1377e8f51448" => :el_capitan
    sha256 "6c4b0816c911e9c00ef3fa4fb7ba9e50f4c2fe3b5421f93254969e72a18c4d2a" => :yosemite
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
