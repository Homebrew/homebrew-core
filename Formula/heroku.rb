require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.19.tgz"
  sha256 "c46e8c4f44126ba1f9a3ea19439bd75bc945aa52cd5b6cf8b34759a333fb70cf"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f387a0a908e0a8aa989ed8a5c34ba7d45fabf48f5cda66f9a594148173ce8fa" => :sierra
    sha256 "076c00cb3efd4c9c75f2b48057b76b33108081fbdd1f388af94e1da6eafb2336" => :el_capitan
    sha256 "60f2f21d898d3ac7ee4a96a7ba7e4a928a0b301ac4066fc046d114a6562c79fd" => :yosemite
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
