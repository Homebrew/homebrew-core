require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.13.tgz"
  sha256 "9a56a156b1e738899e31596a0e82cfaba6d3d7c22e0193eac6628711c0325177"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bee1b2b8c5f00cd3cb031f4209b1af6b1376974d316a3e88d6fbd04dd9a19b4" => :high_sierra
    sha256 "b0207df784855a60d530b4d18d3123c2f3508cfb2823e8fa7967361138b314a9" => :sierra
    sha256 "48890c98dca429cd5a78cae5b1fdb967d8d52a3db9d935dbd99db3f4cd2d2634" => :el_capitan
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
