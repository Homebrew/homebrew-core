require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.13.tgz"
  sha256 "108f251179853947b48ced7b6a6aa2df07c26d5d4b9d1cad93e4f99a53f0e885"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd7ba35bbbc4930f0bc695cd181b9144aeeb8d46d6ddbe238cb308f4bd0a43e3" => :sierra
    sha256 "335fa4288bfdc58eae4d697ef7c6d18b39ad38b3db31af3cef06b6b59d5685f0" => :el_capitan
    sha256 "dc4c75df1e7fae7dd04cc613d869d00474c859d7ead2fa40da3fe40512e66269" => :yosemite
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
