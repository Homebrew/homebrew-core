require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.26.tgz"
  sha256 "6d3ec6ad1890e68284a3f3d3b70730312cefcb5660196cb70fe27840d66d6c8c"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94773557f664129ea8c936ba0e03903bcaa892b2dccb12f65c47cacf037dd18c" => :high_sierra
    sha256 "f5e4a4d8da7f7e2176f6aaf566d08e0557dac4fcc3c04a42702166a1b04994a1" => :sierra
    sha256 "e43d5f8ce4f1b7f284993e3fc98d9314c877c957bd2237483aad4037001a3e02" => :el_capitan
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
