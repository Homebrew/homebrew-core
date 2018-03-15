require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.32.tgz"
  sha256 "d92d3da2689ca3451e805cd72628a829df878a6e8d30ab3dcc90546fc96110b4"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "46d4397764a949c21557cffcb51d8798ed1e87e0482a4629cd1ac3aa78263706" => :high_sierra
    sha256 "d97c9ffd2e900f5abe1ba6c53b605a20b08c46af55b4bb9515c8a2cdd9f31607" => :sierra
    sha256 "fc9ba4cd7bded9eaec040cddb131a36ca32bb1263cf1438e0aced0ee8808136b" => :el_capitan
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
