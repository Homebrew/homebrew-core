require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.13.tgz"
  sha256 "9a56a156b1e738899e31596a0e82cfaba6d3d7c22e0193eac6628711c0325177"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "408da87a9f5d862df0947a5c4ddbb9680509605f217a238d57af136090f2495f" => :high_sierra
    sha256 "0ec1b5ed53a8bd3e9e5ecb7f7e7e0bc30ae83eb90a6b71c3420d2bea8d987192" => :sierra
    sha256 "35f75d452fc4e08088259a85946275f85358af7cc9ef8f50242b248b27a2706c" => :el_capitan
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
