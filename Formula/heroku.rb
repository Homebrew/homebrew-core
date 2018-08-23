require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.12.1.tgz"
  sha256 "4d4037d255582c60d75cf66d59abdd4b00651646e5c90aee6fa65f7b86809489"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bca832e33509f83b64bac6d2d5eaee6f09b3dbd71314770e5b08455e3389dbf9" => :high_sierra
    sha256 "ca7f7952c97544996a3f73f726f020b5372b39524c915709202e3cd403d28752" => :sierra
    sha256 "e3b8a0e0142d6907ca2115c2d1ea1fb93986ef21184b4b3aae64de1a1a4bac7b" => :el_capitan
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
