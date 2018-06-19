require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.100.tgz"
  sha256 "96d1277c8faa740d8e8d8cf047724e5bca041dd3275cf24d72154b830674bc0c"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8da3ed3c54f3405249924fb078a8278a2988f8b9c190724d72e2518ff346798a" => :high_sierra
    sha256 "58f27cfb032853c123c15af2a3a3d5e84d7ec880159cee73141b56206c658d1b" => :sierra
    sha256 "ea99b33aab7a011d1e98ce4863ce803132f477288d34f2e8d55122f5cd889a11" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run", "#!/usr/bin/env node",
                         "#!#{Formula["node"].opt_bin}/node"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
