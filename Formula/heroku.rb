require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.15.1.tgz"
  sha256 "51d91148d716039ffa4cb1ba2c0e1530581fa23e708d2ac77c1f7e83d1ecf7d8"
  head "https://github.com/heroku/cli.git"

  bottle do
    prefix "/usr/local"
    cellar :any_skip_relocation
    sha256 "5505495cee468c816d9c56d7c6a9c845bbdf6e3c0f1439159e8913b6415a15b0" => :mojave
    sha256 "fc51e8bcebe8e299a48be3842c7b1555865c8766011e09694505f2e272ae7bc5" => :high_sierra
    sha256 "02b8433da035c14bf0da37069bae2f3f0505446c0007d2ea28a0fd633d0f6827" => :sierra
    sha256 "89dac5fcff802489988290a2fdcb9fd326c71dd766bb43774f74746e4b92f874" => :el_capitan
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
