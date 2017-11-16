require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.37.tgz"
  sha256 "a2a5bf64bdb17921ce35695d18696c85379afa95416a5213ac3bac2f6a8af780"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "471845e67eb92120f726803df9942a71665a5deb85096381a828eadf7e59d831" => :high_sierra
    sha256 "794389888170eeb98218ca5a0a1066b976f5904b0ae3c10d581bf33e4b8319c7" => :sierra
    sha256 "aa0dd473d2cbd42aecc8343b3de3e5d821575b14b7076557e5aed053ff2cb03c" => :el_capitan
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
