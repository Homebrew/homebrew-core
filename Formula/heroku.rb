require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.19.tgz"
  sha256 "4f060fb91862b6e66c252a62d37984217f09c5d2120987144b1170431e15c5a0"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94d04509d728ce8f70c2ca7fd2cb0b9f83f88c12d3591a307064882f754b252f" => :high_sierra
    sha256 "47fdb11f413858c8a1f43d5e532217cee5063d7597c538dc5ff210bb02018993" => :sierra
    sha256 "62cd0eb88734e4c3d2438faffe3c06e42cbf5563c34dbf9bbababf01efc0bb7f" => :el_capitan
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
