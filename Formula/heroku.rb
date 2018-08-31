require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.14.2.tgz"
  sha256 "3356034a5f2cfa1e9fe7b9c439d62669524674628dd0ae895a8936ce77e5d224"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d8e67744d4d1e96b056fcdcc21e0e6d12c0bf0673efacaabee20afcbc34b08a" => :mojave
    sha256 "aa055c341496f05cac1d9d7abc9bc13441edc2af1f870eaf6a8bca6b8d8d048b" => :high_sierra
    sha256 "70e07c7a9e9c0be316f728cfc4391900ab5909351a478a7f4838cb3b674eee2d" => :sierra
    sha256 "9a4f84d19270a979b00671ee624631c0a4606f0903617890fa49f79e9ae1b667" => :el_capitan
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
