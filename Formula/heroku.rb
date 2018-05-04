require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.25.tgz"
  sha256 "1f4b9a41c09dd2c6055eab797fa971fd8084bdc3b39cd286b52ee6d9832a3163"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b911c75d4cece25a0a3089c5961c7c628f3215cf82ce1868df2de81c6f1d4f62" => :high_sierra
    sha256 "04e0eb8e54aafe3999b89478c617e8fc16b750ad5c830416d69fc5ba4435db0b" => :sierra
    sha256 "f18e2f0b9245ff380bdee95e174cbc42c4cdf17c333950442652859876e526c3" => :el_capitan
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
