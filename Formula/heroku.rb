require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.17.tgz"
  sha256 "bcc154f0528eabd2600cd32d1900ae608d18cb7b1ab2bb26864515de0b81e861"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94eb7016e2a1bc35c62833fd5cbbc7190a19c86d363823c73c884ce3b10f6bd8" => :high_sierra
    sha256 "42024430259d535caebc77c7a8937ff93371f722787e28b003da8529df0ef133" => :sierra
    sha256 "7d69858583c20c0c338298ef105a59d88e0bee1181d3158a07cdaae62c1dc079" => :el_capitan
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
