require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.39.tgz"
  sha256 "d72f743356615f0483e89326e725bdceae542abc042e68e4baeb0aad9cda9384"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6f5aa182c2abec8fabfc8ca785038b749863922ad2a4f42401395b708fd6047" => :high_sierra
    sha256 "9dfb69f04c584d07ec755ae001cfc6684f4669eb1d78e49289e19de013ab0f29" => :sierra
    sha256 "50a8e4509f002be72e5e17e7068caa4a4f00850b4b454b30acb30829a7ee73b1" => :el_capitan
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
