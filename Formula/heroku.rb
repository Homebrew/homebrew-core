require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.5.tgz"
  sha256 "91ab7879b24f3a7f1cf39b92d9ef82d0f199827771d15d0f551815fd951686b1"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ddff8edc168b7d670984e2ef13b6a543932e0f4a667ce3b59a09ea8092c05a3" => :high_sierra
    sha256 "e0ef9f742cdea825135889d750cfefae0179515c3d943d538e4afb5277aa5990" => :sierra
    sha256 "1ad91c15f5255b3b1d0b283fd72b65295ebc13d5231e4563d50b98357a8cf599" => :el_capitan
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
