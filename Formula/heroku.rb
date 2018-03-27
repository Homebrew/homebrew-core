require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.3.tgz"
  sha256 "10377bc015629e7eb34d40e8eb0cfe2a232a297be574d4226c413aff7c268758"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0aaa78c2e12d9f3944b19f1b632e0c5f805c3d66308116376505141c9ea564ad" => :high_sierra
    sha256 "6ed08e21d8eedae28aaafda81fc4068b992ebe051af572dd84d3ef697f7cc4b4" => :sierra
    sha256 "18b4cc354282e5c70b147907c1777da54665e2949fd31a0f475bd3e85bafa3ce" => :el_capitan
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
