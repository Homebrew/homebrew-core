require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.8.tgz"
  sha256 "c3de09839cdfc9c4205290656b99983aa5c70ce96ac10d0b2906c85eb61573b8"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "557e4c454ec384e6e4cc6ab69360cdfe0694b6829f961635c512d1747cf6d6b9" => :high_sierra
    sha256 "6acf9c68dc93e406472bb5ae225af160fe869d918d74a2be7934b57a9ec119d5" => :sierra
    sha256 "f6e857254c808a29503ec300290246be491627d4fcf98bb79d648ad3a1e6d4d6" => :el_capitan
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
