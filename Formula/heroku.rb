require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.5.tgz"
  sha256 "f52be678871987acc039073f9c29904dd17c8b48c8f72c86bcf2c5e2ef91c0bf"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc7b5743fd5c5b859b5963d4d9082e6193ec713e5bf34d480304d3244f0a9142" => :high_sierra
    sha256 "f3f5c200ccff2718b591bb1bb258251ef12ccaa8e5eaf5d0efd27c0e6c9008c9" => :sierra
    sha256 "7e6546d30507b0b824c9882fb7792f78af43fe9725c8df8298f0260495a5ab20" => :el_capitan
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
