require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.26.tgz"
  sha256 "dbac81d7079b60b696dbcefe54ec845a522c81e219598371edaa2fa3e8955ffc"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9075fc223b0f871ed436b5dea284dd73c8b68b6cd21795cf2d80f4d2306e8405" => :high_sierra
    sha256 "7bbf9e3b8d4be0d5b379c2b20682bb9a7129a9c2ff92bbc9c1142ca3d98d1d04" => :sierra
    sha256 "e964b808e0b02e46b3504ae1cdeb0a11cc57dec2a0c9143ea39a7729dbbf676a" => :el_capitan
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
