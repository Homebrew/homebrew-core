require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.12.17.tgz"
  sha256 "1a0e014de6355d90ecac2b7a95394160f08245b9630bb92305f3444bf6b6446c"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e54e44c1e886a9fa2c5567a8017d6d9935ef97e26a349f1f5216e4a03f1cd90d" => :sierra
    sha256 "90aaa926ab24fe12bc883fe29c2ff0d1cd7ec513337bee26b35e99714b53a3cb" => :el_capitan
    sha256 "0ec5ed3e76c2b6616410ccd8fbcb793d1f9e4fc02a90400ccaa3499eec14ae0f" => :yosemite
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
