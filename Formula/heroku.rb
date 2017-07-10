require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.12.7.tgz"
  sha256 "9348fab0b5928a6cfb9e537541afc5359d658aaff8e7d9d5066e142c1f99ed3d"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9735f1bb6cbb5c8861a9282d3bb4dc59b4c62094f123dc28db8f53205e7eaba" => :sierra
    sha256 "c76398aede914c22deb7530ffa8b3f972b04c3cd0c75ca8be214ce9877da1da2" => :el_capitan
    sha256 "6226e7a97dab4aff2c933f5ebc5cd1b5573aaab9fe87955d61829a6ae9ccccc7" => :yosemite
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
