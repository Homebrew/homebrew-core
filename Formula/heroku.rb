require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.17.tgz"
  sha256 "bcc154f0528eabd2600cd32d1900ae608d18cb7b1ab2bb26864515de0b81e861"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ba978716b01692166d10875d5735f967712014ea9de9a667c1405b6a3e75094" => :high_sierra
    sha256 "e50f0ab75ee5311706df8050448100523bbbe5a85fe023e0853e9e98fc4540d1" => :sierra
    sha256 "544783a964ed5b6617e79729f278f0bf8f321d79e3a8529e7dac2cf5aefb2b48" => :el_capitan
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
