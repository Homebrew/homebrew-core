require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.28.tgz"
  sha256 "80ec9e34cdeca33b5fa268d0dec49483878f756693ac30f0b57b59a449f90c2f"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a469467d9e8c934aacad5a244040503d8ac1e565c53ac891718d733a39f1a357" => :high_sierra
    sha256 "721ead2c154f28121a583958a61f536f24cc73e9e2ee115484ab1960addb37b6" => :sierra
    sha256 "0ed6b77cd3b37ede0c06ac502f1e036d9af1e63e36d89dc918f3a9855b3276fb" => :el_capitan
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
