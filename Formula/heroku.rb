require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.6.tgz"
  sha256 "8bc5c5e4f35e6a65866b28d090a9107c97646cad079f0d25f02eb205d0fbec9c"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e76fcc0a633fc509c4d7f57d0bfe1105cf75d7b47f5950aa22f5599e00b0c8e" => :high_sierra
    sha256 "2085a002691620bcadd52773833164cf7835ddba97227db44ec9695b7e8fc7f4" => :sierra
    sha256 "94a086f7e5e34b753814723949d6c607e2257d3790ade22692037e14b0d203ef" => :el_capitan
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
