require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.15.1.tgz"
  sha256 "51d91148d716039ffa4cb1ba2c0e1530581fa23e708d2ac77c1f7e83d1ecf7d8"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20448386ca27a11b4ad7a1c7a43c895e3dd23e7ba0d1d99b0fa2fecc8b8262a9" => :mojave
    sha256 "4879b0140e86fc83dd4bad26df554157dc91232f4f5de60f1bd15b5bfea91517" => :high_sierra
    sha256 "3c693df3f580a079b35c2d55f6e5400cd87056eca173ed8e45e5992d7a6ea622" => :sierra
    sha256 "22bb36c8dc835c9651d8ce7a3b8df61aab4efb5d3652b6d9d39c8c3a1e60ffb4" => :el_capitan
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
