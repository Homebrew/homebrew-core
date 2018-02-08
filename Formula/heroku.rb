require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.24.tgz"
  sha256 "ec98fb3f368db8a40319b0faf373f0ddafa952a32204482857d6113362076f52"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6260da579e541c87ca96e00bc3684ddfbb67a9f2cba4ca0932b87a9a855fe4c" => :high_sierra
    sha256 "b2f895008aedc3fccd63b64295f6ef9bdbf5686b035f89480b9f69ae59cb8eac" => :sierra
    sha256 "f1024dee924345d9bb1515a64dd7caa4a4ef75b40910b733d0241c3c908e92fa" => :el_capitan
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
