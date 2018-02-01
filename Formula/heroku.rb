require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.20.tgz"
  sha256 "0d8650ff2fd44405fa6b9d8d32f0ff52cc480afd7ca1db7b1410a582084d58c6"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba2c6e6eceb1457347a99d25e07c19d6851c5a715e782c0e0118f8ee3e657249" => :high_sierra
    sha256 "7d06bb4b5d611ce6efd0b4fdb3fc2cd5a0b5e35b86dec459db641a018e2f3f07" => :sierra
    sha256 "18bdaa57690a9b6171d4a4fb4473aeef98dbc6150e2c6d848ed082f74b5565ba" => :el_capitan
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
