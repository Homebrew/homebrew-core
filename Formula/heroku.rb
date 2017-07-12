require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.12.8.tgz"
  sha256 "51794cc5961dd535f930ec2d161f84be9cb50e0d216a3c3a293525ce23e0a55c"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02f9741dfa0d14289aec176d1067cff81dfc3be9c3121862141e341df7a0c768" => :sierra
    sha256 "9d17e4e7dff2f1c78fbdcba1dec0c8e9fb3d80fd5ae5f16cb14d362a43b7da4e" => :el_capitan
    sha256 "1697286edc8c7e5f201efa258cf14948ce3323bac80d355c8ffceedf560cdf73" => :yosemite
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
