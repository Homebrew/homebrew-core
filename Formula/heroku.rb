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
    sha256 "883277dc6704d21a45723eeac240ac8a0ce46458914dc065d9523eca910df308" => :high_sierra
    sha256 "36c5d6381a7ed1f99dcedf83d9bf397f96a4fe2e827aca33d2a3f6aae49b5005" => :sierra
    sha256 "a66a9df27ae5ba1fc471175c1d0277f159c9e1d1792de92d442b44b46cd3f296" => :el_capitan
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
