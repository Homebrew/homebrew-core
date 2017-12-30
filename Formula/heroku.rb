require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.44.tgz"
  sha256 "d20a83fca2fc759570176563811a7e0d17cb45e0d7dd82aa0e87ebb6f82017da"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b24815b1a366abfd65bd46f6580b80f8be6fdc233e8d8854ae440e34662cc33" => :high_sierra
    sha256 "d6a7c1850e31412f8f7a6e88bc594cad53f57ed545f004df2870bf09e23166dd" => :sierra
    sha256 "465e536a5fb541c4f9cf1f4f6b6d4aee490e1878d5f4d71ba025f518decf5e1b" => :el_capitan
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
