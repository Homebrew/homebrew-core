require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.4.tgz"
  sha256 "d91db4c282e5ae1212055a456459466c8db983f4359874f5998c1a5f854859af"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "971e1d4097bfd92c26df0657006fe1e3e0a4e751c476113e2dd6e71b8535d3e4" => :sierra
    sha256 "c81c64795fc331d81fd898709ae00f5edf259908fc45094f4121e70cfe2db443" => :el_capitan
    sha256 "ac8707ee694c07d9a882de6b021d49096a260a03babbbf8171b6c5c8f0acbd5f" => :yosemite
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
