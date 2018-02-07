require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.24.tgz"
  sha256 "ec98fb3f368db8a40319b0faf373f0ddafa952a32204482857d6113362076f52"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a51da3b659a170486fcc70809a341003d915fcc1d4d0fa3173c77aa3a07889c9" => :high_sierra
    sha256 "e5b68548d547c7c4199813121c6d34a3b384f3e1f078102b95ce42faea223e95" => :sierra
    sha256 "37a8733acd4d08cedefecc7279f4acfde1ac3e20e443a05f57d75c40cd34909a" => :el_capitan
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
