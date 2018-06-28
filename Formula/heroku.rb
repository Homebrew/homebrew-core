require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.5.0.tgz"
  sha256 "e3e66b26167379b4d6ce6f40d7ca3f3bc89beadf75c26d01add8f84c41eb0381"
  revision 1
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c16e2c49f9dc2769c3555eb4922a632eacd583b09065c8f5fa2fb617769bdd83" => :high_sierra
    sha256 "25fa92a801870c2b7d18e2c7095ccc112c6f83166ad310f62c2337abdba03e0a" => :sierra
    sha256 "fa8ec470081dd2ff13a63eff3147d10c9d0630a8a1df051c48c720a68f29d172" => :el_capitan
  end

  depends_on "node"

  def install
    # disable migrator
    inreplace "lib/hooks/update/brew.js", "if (this.config.platform !== 'darwin')",
                                          "if (true)"

    # disable outdated check
    inreplace "package.json", /.*plugin-warn-if-update-available.*$\n/, ""

    # replace `heroku update` messaging
    inreplace "bin/run", "npm update -g heroku", "brew upgrade heroku"

    inreplace "bin/run", "#!/usr/bin/env node",
                         "#!#{Formula["node"].opt_bin}/node"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
