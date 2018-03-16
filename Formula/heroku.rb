require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.35.tgz"
  sha256 "872a9fa8210f025d6466c9aa12aead284805bb0f9bf0eec46fe8736ae18dc65b"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c83c9091d4db36d0f9c30b469e89c5b68fa06910f56e0617e364e5d59979b09" => :high_sierra
    sha256 "c8763731299bee54f1b729d126a1448332ec1ef6a8a30ca2273d01d2efacd321" => :sierra
    sha256 "3b3fa26d0d0518ad8900ff91147a5d15ad389c7a61c456d92862db4854d327c0" => :el_capitan
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
