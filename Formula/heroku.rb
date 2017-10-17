require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.35.tgz"
  sha256 "dc1f2452b1ac7242fb01010ce22e50d8a469270429c94827906013a024a370f1"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6b3c8de74180dd8ee63455714cb5c1e4902b0fc0b9233129e8e79f7309f2c14" => :high_sierra
    sha256 "6149d3470de55a0beecaad63fdc8e6cc5a9f1a624b32c9a36b9014f0c9c7cc57" => :sierra
    sha256 "bdf1edcb36c1998c53a0bf4b3e757f6ab432abcbdb2ffcc8a1abf3974f4afcff" => :el_capitan
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
