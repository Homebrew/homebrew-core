require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.17.tgz"
  sha256 "f49875142bb4a6c65a12e5c32761440270d6a337c44105919b11131afd71ca35"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab1daa6d390e794f1cf0103aee8596f586575c9cc72915d63e14b18cbf416511" => :high_sierra
    sha256 "28774d1dc356fcbcd37aeb40daff430b8775fbeea643395c5da482a6208a29b8" => :sierra
    sha256 "01df26cf3c69d6cdcc013c1b728c95f8e0eff3008401090fbc3a4aebcd1c0816" => :el_capitan
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
