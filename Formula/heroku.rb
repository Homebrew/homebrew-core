require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.50.tgz"
  sha256 "184ee97da2e43b2191f7a5c4e4f48e881e7c9d6d6fa08f6525717b5d8485abad"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82527b31292977534d72e0c207c2ceec3b5de9fea57142db82aed945595da8e8" => :high_sierra
    sha256 "c49fde50a7af6f642f96ba0d926b12c246477f5a589751cecaf24de0bd45b61e" => :sierra
    sha256 "00e0e062e807066a8ff45c3586856e15b4e4068edcb9fcbe3d89151aac38ec98" => :el_capitan
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
