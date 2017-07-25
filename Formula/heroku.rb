require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.0.tgz"
  sha256 "80095c7d7e65dee9b1275686d60fda45c503252aab00c213e2b38fc5311fcadf"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0de4784def882bd98eded36d4f87ef21b9c1605714c7951e95a7600c54f96a3" => :sierra
    sha256 "0544e7451df01e130c2c004969df81d7be86fe50af2b90f28c64362a5c219241" => :el_capitan
    sha256 "5b971f3c41d8348c6e857a4ca199a074a6d213d5a6d7ae1f9394c2d6ae245b2b" => :yosemite
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
