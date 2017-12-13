require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.41.tgz"
  sha256 "568a422207321662e0db17d83490eff9b47fbfa023e2ed9b81175426c892cd14"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ec185c3cf2d0e83635926a26632ab3fa703eb909a7e60bc7a96170ab3e50359" => :high_sierra
    sha256 "4d9b2be43f1f1bc8953464fe11d2e699c02d0a6b7861f6b60eb7056a75c3ef9b" => :sierra
    sha256 "9d0bb93b75b7d5bbd3859381d8297913842bce8c1f9e27121ed9ce3293dbdf8f" => :el_capitan
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
