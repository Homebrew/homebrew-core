require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.4.tgz"
  sha256 "b48bdc3b146fcf29c84ee65133c6454bf746c1ac041ce2106504b351b9637f7e"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38fd2616dc99b8ce51fd928c9fbc4e36a423778e8da6968b0d729f71b9991f26" => :sierra
    sha256 "65bb8f24f2a47294e1a88da7a9cc8e6e94bc8f3bdae9add627ad39278a89371d" => :el_capitan
    sha256 "0f35fac4ca49f62b544262b9124ffdd7d4e7b9881c715b56937d8b4825f3cafe" => :yosemite
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
