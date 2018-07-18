require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.7.1.tgz"
  sha256 "c0b07034e3b1d458d9ac74579d5c35a6adc6530e7145212cef1579d5595a883b"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9265af60f2972804bfa2948c9035d9a69a1c0ad9fed100241a612ce37b5afdf3" => :high_sierra
    sha256 "8e4e14467305e1f366f02e5ba10b46fe70c04358244cef5909c1895215d326e0" => :sierra
    sha256 "da121cfb000a2906782de9633bf4e66e49e6d5fac9c68e8d4f3d46ec6caa5c9c" => :el_capitan
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
