require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.44.tgz"
  sha256 "d20a83fca2fc759570176563811a7e0d17cb45e0d7dd82aa0e87ebb6f82017da"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d290adb4d57a47be98b915d3771af4968c6d832f317222c2f4fbcb75bcf60077" => :high_sierra
    sha256 "b03560ec59e5d9d49fb4745678c9be69908c0f81b4ae00eabcb9d1504f6f1c65" => :sierra
    sha256 "649bf94dc3c87be9cbdec40e5ce593bb621401d4381380515b8ea5960e16bd57" => :el_capitan
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
