require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.12.tgz"
  sha256 "934395c3aa9ddfcd9ab4c160674e32019234bc87a1376da7e5a921c6651031b8"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "132a34dd2eeb567c7af9498cf9ba8df67abe60eed64aea67f9412c5f082c0337" => :high_sierra
    sha256 "912f634786bd9b475cf246040426a7443f43146f0872fe1742a6c487ffffdd14" => :sierra
    sha256 "348ed0c0cabbdb62d30f7fbd7639d9b928a1f721590542b3afa71a19bbc8eb66" => :el_capitan
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
