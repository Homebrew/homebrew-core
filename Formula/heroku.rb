require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.31.tgz"
  sha256 "6f9e78e2fa01ed1d385e08da64864586f11a79f99c27f902a95be2cdb2fda884"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e7d11f10fc6324f41d6eb2890a3196e79ccc10c9076acd395c82c4ad808ee30" => :high_sierra
    sha256 "c0c4d060d417d7b52b1ba8674b5c3813c5ec1d19a25418f494e0c90bb98d0e44" => :sierra
    sha256 "e7d0aec55fe7c62da6273f61e2715cfb5b2ee69dfbf7e1af2a0d10c08994d027" => :el_capitan
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
