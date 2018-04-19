require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.15.tgz"
  sha256 "ccbe729ab1bdb405e662775631b1fc558b681bd2bb3a0032630b3f3cf5dcbba4"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "989b158f4b7afd03375cea5b44e5830a2b51f47d9a4a2f98563b8b6313b7e66a" => :high_sierra
    sha256 "61f8b69ae7819ae5a5672919e18081062f2b5e1d9a5a6839993fff5345bbd055" => :sierra
    sha256 "47f6d1ef7dd8c4f5db08de4587f60c977814c4b945d4e7c216337e75092799ee" => :el_capitan
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
