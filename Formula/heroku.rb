require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.13.tgz"
  sha256 "1809598ebd2cc2e91f60e68478c0042555773ce6c2d6bfdad1a8caa62606d2e9"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ee757298228a77dc17342418f46ca2c80eb11ae7c578fbc65d6497c6bfa513f" => :sierra
    sha256 "f6eb9fb97ad245e639e619ac0c39c023f54d1a8faae0269f782fb4c9a1afaa3b" => :el_capitan
    sha256 "8b0f8409fa3bf56a25e891b90c6b444a745b90578cfd39ff7b670fe13872291e" => :yosemite
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
