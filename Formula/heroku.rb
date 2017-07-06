require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.12.5.tgz"
  sha256 "941320b806922a4e9d9035844991f28458ae7e52c32080162d26f4c947aa2636"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f72601084952494a4cb9ad989093f8faac15c2c4d421db4db683c8fb713d82dd" => :sierra
    sha256 "d197cb57a817fa932bb5746de1407b09fbeab607265301794ca1af9dd1eb6ae8" => :el_capitan
    sha256 "f2a023de07e9370aa489fc3b569d0001e3d2b1604e96f3e243050e36da68fa8c" => :yosemite
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
