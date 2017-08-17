require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.18.tgz"
  sha256 "cf22155c7d74d9a9a69e8e22ae5a3550b27e6543a44669fd78bcd10a881c3e07"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e24d8f57c5c11c029c59b5de2ea3d733d2f87a6a7fbb698b44e4b7c1ca4d0651" => :sierra
    sha256 "71483d9ab528aac5341ce123e4c579aa3664f8ef001d5ef96e0f45137a7d49ee" => :el_capitan
    sha256 "716e8f9577b3d9f7965020fc2eb1376d68f108a96660e9b41b91c3d3d8a4fd87" => :yosemite
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
