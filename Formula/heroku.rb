require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.26.tgz"
  sha256 "dbac81d7079b60b696dbcefe54ec845a522c81e219598371edaa2fa3e8955ffc"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd59002a68796eecbfabbc71dca2e724af37abd15f8ead48971e886f93f2e5bc" => :high_sierra
    sha256 "ee3e7278f3d0b06695ff32d8503943b483fa2097e820f0d121dd7f2bb3065fd6" => :sierra
    sha256 "89045a5e724694e5d743da31e51687bace9381978a128703fbb6968620b484b8" => :el_capitan
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
