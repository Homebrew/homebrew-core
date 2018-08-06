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
    sha256 "71abf71f556dab06bec160f71bd8ef992c2fe7bae209ad7258c3335efe281dea" => :high_sierra
    sha256 "b26dd90e75cfbae5c32fb25f80a42a9261dfe60e9c3725637c7a703c7ed7a4e1" => :sierra
    sha256 "808af2964b70ba829c6426bd6e86e90b9bf1bbcdd736ba6f02de10b36524f586" => :el_capitan
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
