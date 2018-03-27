require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.2.tgz"
  sha256 "996d866e883a6ca0b109bafccd2053be39dc6e59016aaf8cc33c1f75e98d4648"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e4198dae714a93cef7caebe3c12c06334e486b4ad7dd0c8f1feb850d2927ff8" => :high_sierra
    sha256 "53bb3bb36adf68a49c716e133a25a84dfadb264d76254794395021993b1ed517" => :sierra
    sha256 "bbfd9c776541c90d5920ed8fd6242c3abba383091f78b3b74d47b010daa49c20" => :el_capitan
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
