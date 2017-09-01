require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.11.tgz"
  sha256 "5bf273c0b3042be4d9e37d9605a277f4f343c4b47bb9fc26199b2374a7bcb704"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1c12dc6c56d1e9b3f12d2fc1ba84edfe20cfb515506cb7bbaa39151eca31df5" => :sierra
    sha256 "dd84482562cf15f8b104efa0872c18fe33063af7e9db1273e6f78af0ee4bf21b" => :el_capitan
    sha256 "e36fb3dbc445429d9ba9a85673762783620d4b0eaa6ca302b985e763b60483cd" => :yosemite
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
