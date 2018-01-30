require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.19.tgz"
  sha256 "4f060fb91862b6e66c252a62d37984217f09c5d2120987144b1170431e15c5a0"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de6727eca01f8a5d317adecc39697856e5507aed3060447e3dbb2effcca3dba9" => :high_sierra
    sha256 "9a1fb31190653ba5115015fcbf1b314da294a10bfdda405da731471c7148d994" => :sierra
    sha256 "1662d57cff872ddddb9ee9194fc6bef14a5f74b985a267a14accc338e3026329" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run" do |s|
      s.gsub! "npm update -g heroku-cli", "brew upgrade heroku"
      s.gsub! "#!/usr/bin/env node", "#!#{Formula["node"].opt_bin}/node"
    end
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
