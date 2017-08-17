require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.18.tgz"
  sha256 "cf22155c7d74d9a9a69e8e22ae5a3550b27e6543a44669fd78bcd10a881c3e07"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfa3233a82eb28afaa756748884205eb364326629101e8ff612754ae261458e0" => :sierra
    sha256 "6a2caeb22c4f7e7b44eeb7f0c9819e56bd190b696416b9ce7a2d1129f1c54ff7" => :el_capitan
    sha256 "dd971eea2dc6f4639213eeab0c657fb342414d2aec7f129a7c1fcf24f66632e1" => :yosemite
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
