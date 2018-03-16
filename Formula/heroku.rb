require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.35.tgz"
  sha256 "872a9fa8210f025d6466c9aa12aead284805bb0f9bf0eec46fe8736ae18dc65b"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c01322664986334dbdf74b58f703a4fee90524c4caba0fd20cdd5cef664bf3d" => :high_sierra
    sha256 "0600a73881c420dd3087c972bcfd17fe9b7413176a1a8c5032bd92623cf9a361" => :sierra
    sha256 "2daec8053dc249314d331286f13eeab8637f91b46fb460987a08ed34f8cd754a" => :el_capitan
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
