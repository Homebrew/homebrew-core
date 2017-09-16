require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.22.tgz"
  sha256 "29a5c88a0f8ece242c2ac6403596b69511773a8f36469c4f7e8de191020601ff"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af48b2b592520ede3f7cbb254d31520dcb55611b3bb88811fc5af33d44e77fd3" => :high_sierra
    sha256 "95839311fda5e4ae224e5714a3c3c9c19a74978e2fa23f2b8ca44dfb0b0cadfd" => :sierra
    sha256 "47837ab21d1bcb4c6ad3e57f5463cddbcc8ba4cadc2bb5c9832f8a70c5ae5fc4" => :el_capitan
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
