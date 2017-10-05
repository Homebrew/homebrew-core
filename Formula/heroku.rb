require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.33.tgz"
  sha256 "be1c1447d91c483ed1db1dd9f8ada362dcab2f1d1259e4f903c60e941dfe3b65"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2465e3eb06d1a1aa91b2a993c0d5ba1bfae849e372dc05753d13777669e2c2f2" => :high_sierra
    sha256 "c932d14700bc6cd91b7af1083235230d2665aa6e42526f609baa88dadf8728fe" => :sierra
    sha256 "9c7326df9deb67dfd32ed5421176a13f8267eb1ebde7d9929aa062268dbd72c7" => :el_capitan
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
