require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.13.tgz"
  sha256 "108f251179853947b48ced7b6a6aa2df07c26d5d4b9d1cad93e4f99a53f0e885"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65ff458813705f14f20f424e6df1c2b35688c4c3860f1f4af3af9e1dba136eea" => :sierra
    sha256 "5180777ef7f5e48acb737d4c1a8381f8a4d8b5749930b4754272937a04001229" => :el_capitan
    sha256 "cd3f1f34339684f99c8cca651ee7f4d3890e7a2861b2653427be529fea1130b5" => :yosemite
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
