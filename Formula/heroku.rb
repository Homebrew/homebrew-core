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
    sha256 "63b050467b418e1d4d4b5062a21085b5a767d4f16586becae5c36193e8a60f6e" => :mojave
    sha256 "1d2a793a34a4e1fe07f41a2a65466147247ff6133afbd06488eae989ad7feb36" => :high_sierra
    sha256 "8b1800a51a6175b51d59d2da3b43840d9af9e3c23d29c526cb9a4f6d8ec898f1" => :sierra
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
