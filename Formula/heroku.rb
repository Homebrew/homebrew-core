require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.37.tgz"
  sha256 "537061702509b64ab9845bde1e04b34c58f1c39b5dda6df481560c4942b11ca4"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "430297e29e8d363f5f98d6b5eaff12f5d4d3ad96fe661780981159dde7273077" => :high_sierra
    sha256 "2a2e639e283bde3216c5764d9023d030654545bc13750e480b64a60f45a85a8f" => :sierra
    sha256 "5059cdf5c687884be8310a756cf18f9b160c404ac4c149382c4757b6d506e034" => :el_capitan
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
