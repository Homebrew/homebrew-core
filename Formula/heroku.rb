require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.34.tgz"
  sha256 "b37f29699aa4d29d5b8ce0db2c8b06ad73ed3127b330897131bd79b8429dd4b2"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b07c846476b34bea22b3dfa0c1eb646ebfa5f64c88ce4aba594e2efaf5ce11fd" => :high_sierra
    sha256 "e794e43596fa01ca28d46e23107df832d9a6a1b3d2943dc94d83d7416725ed6f" => :sierra
    sha256 "e20a827440a5c29feeb311de682aa8c85b70b6e5f0699d945b0b7cd10c14254c" => :el_capitan
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
