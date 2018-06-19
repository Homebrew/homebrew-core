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
    sha256 "74852e0f8db98b207e3ec5b0ccf3f6622d213e5f9b486e15298a0b95383ab1fc" => :high_sierra
    sha256 "22fe38c8553e49480ed9e6bc7d9bc49c6c8d72b074dc70932a4c3766b1ec2faf" => :sierra
    sha256 "2504acb781cac31722245ca6b9e2ecd71cf077598f114f0dcb6f8454299945d2" => :el_capitan
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
