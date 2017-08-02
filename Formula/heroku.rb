require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.13.6.tgz"
  sha256 "255c015477bde57b568f12059fa4fdeaf06d8e072537187f182b1bbafe639b70"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e84db69f0304d0d9eb80943e2a588c81bbce54940ecc80e0aee6c58f22c990b" => :sierra
    sha256 "ad233373cddd864732e7bd5f8bdbf1644ba51d0505bfa7376e5e9122e90383d9" => :el_capitan
    sha256 "8ce2ea281f65bcbd504baefd995620fa7442530eab76faef82d65975d1b5b1d6" => :yosemite
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
