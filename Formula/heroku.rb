require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.5.0.tgz"
  sha256 "e3e66b26167379b4d6ce6f40d7ca3f3bc89beadf75c26d01add8f84c41eb0381"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95cd6c56de0e5cbc1b292df82759743e9d443f79b072e2ea3d145f43bc31072b" => :high_sierra
    sha256 "f3c726a58cd4eb5f56d637b9315cebced32a76440d26b48ef95e6cf75545c186" => :sierra
    sha256 "ce9e586585be8af6fd27cb6e1778e77b19a6c6c2597b263637f9d35c40335259" => :el_capitan
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
