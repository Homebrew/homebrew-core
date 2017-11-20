require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.38.tgz"
  sha256 "82bd05ce88e1e6c20379ed73d9456dfd2dea8d80d3616cee72387ca48580940f"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "526a4aab8919883ca555acb37e5c738ad78eb4f1b23b1acbf1595f27afe6eb57" => :high_sierra
    sha256 "352c7c763e2ef775fc2afaed13a14cf65d822482f4f697cdd793982c219fa82c" => :sierra
    sha256 "006329eb040aa35d22554f293fc7b3ec8c978dd4d5a4c1bc9c0b3d0a1c0fcbcc" => :el_capitan
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
