require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.11.tgz"
  sha256 "f774ee704a241cc077be67fca5f00e9d461ac378b982ad98c9aebacb965b79ec"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9484cdaef620fda9014800d30693c184546af0692e4c36730aab722f215c30d" => :high_sierra
    sha256 "80cabdf0eaf5a8f653c44209b448cb4060f532915072204b59db6454327bec93" => :sierra
    sha256 "9a66a9a9bfd55cc19ea657c18ab975949c127d1ce1ce50bea938971926d04bb9" => :el_capitan
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
