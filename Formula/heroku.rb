require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.16.0.tgz"
  sha256 "8b3653c95e235488bdd3599647a0a5255e3f78e421adf776e53a51286f3473ae"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "553432b0ac9358fb22dcd313fa37a3d1868627262fede845493dbc5d0439fac1" => :mojave
    sha256 "592cd387f78048cdd3ec4bd4653b871405d61e7101502c6e9d914c487f1a0881" => :high_sierra
    sha256 "cbe52193619a5a72b9bdf20e4e93e1bd6bd39e0165e9c174ac306b67743d03a1" => :sierra
    sha256 "b4c515c4090e759d600c9131ca0d7c782aa74609694ca800d3b81d5ff601f55c" => :el_capitan
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
