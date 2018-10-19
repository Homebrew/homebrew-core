require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.18.2.tgz"
  sha256 "2a5c2b51ebdfe92d1ef816881f8ade4bdf634efe012e84ca06f8eea2b82b3cfd"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e588468fbc131c7126fc5b5052f560c2fe348df29ccf520d85d4ed58acf55d1" => :mojave
    sha256 "4e2fbbaa61ffee570dc8bd2341f49e11f850fef8041233d149c3409010ff4351" => :high_sierra
    sha256 "24fd0d3890bfff3999f423123635a69160d53179145938c538f7453067c027ef" => :sierra
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
