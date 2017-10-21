require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.36.tgz"
  sha256 "5883c9f70c961158d411dbb584b41f2b9d86593479be52e83176417bb9bcc75c"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f66697f646c70af6e8c6a5d2d15feb303585cd39388dc222f720607c218d5e2" => :high_sierra
    sha256 "f5898f56e63b39666db64309209ef06d24b1ae4a09688fb20b45a56b3791d441" => :sierra
    sha256 "c2b20f6b2faf183167d3d60364ec2ba5b6baff6b28eaf5a09ca551fd5aac5aa5" => :el_capitan
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
