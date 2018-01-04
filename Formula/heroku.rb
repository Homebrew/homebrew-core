require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.5.tgz"
  sha256 "91ab7879b24f3a7f1cf39b92d9ef82d0f199827771d15d0f551815fd951686b1"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38aa0ea4bf5a48e799ac372317f0147ecc45224f2eb5b8625154d83f8a8b2642" => :high_sierra
    sha256 "28a99285cf3c5a9c8b1b07fa95e0792f99934c5574e80fb490e37c3bab4b41dc" => :sierra
    sha256 "eb5623ca88801522ea8be8897360f2a51b2151661119625385f3f0ead7af0e47" => :el_capitan
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
