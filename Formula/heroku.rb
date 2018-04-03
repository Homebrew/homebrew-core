require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.5.tgz"
  sha256 "f52be678871987acc039073f9c29904dd17c8b48c8f72c86bcf2c5e2ef91c0bf"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c2403ce5dd4ad77fb09a379f2fa44d3048320f6c540beff1279699161a29bd9" => :high_sierra
    sha256 "30e4d86fc65a5406ca8b3a8c9c42e0e4df1c9acd9fd14ca81dcdab503f35230e" => :sierra
    sha256 "693cca5f249176848349dcccbdac5236debb1c1986ae6423b64b1c9126570912" => :el_capitan
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
