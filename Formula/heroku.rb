require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.21.tgz"
  sha256 "cb3fa5ce2b1b408358f831358fdb7f16728a9e3f63bff4e3f5ff40b45e9d6323"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc291fd4cdc57fab7b34ca252d9d4fcb0803d992d9698d0a92bdfc25ce141e7e" => :high_sierra
    sha256 "13f810ae31323975b29918e313c8ccfb21f5a716a335602341f6b2164f4935bf" => :sierra
    sha256 "a522db47bb9fd4ec6186dfc78e5a0a490dffd2b3d32ba43e8d2c313fe35b6528" => :el_capitan
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
