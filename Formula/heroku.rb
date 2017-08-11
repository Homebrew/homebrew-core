require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.11.tgz"
  sha256 "6551e7f47622b3b26539a4180ce917ccdff28d56d4f9ac68781487eaa3497e82"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffa030fd6bfb41abc61054cd1865862b5fa3d80d44116bf488fa9f070524a3cf" => :sierra
    sha256 "f6423b06ed736acf8508e4fe48510a037727cec8803f558dbfa811f7c4a43f4a" => :el_capitan
    sha256 "acf77f9c664f8374269966802cca742b3031064ee7dd48ced1c428623a77091d" => :yosemite
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
