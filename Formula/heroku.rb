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
    sha256 "457d4d451237bc588a9fa7053c3298478e336d77b32f27eaf44c56e871df5762" => :mojave
    sha256 "ff88c602b7a8dc6f65acd122f3546ccb80db6bd5ac8b4ed0351d16b2993c4cf1" => :high_sierra
    sha256 "0cb7b8d611ddaf471215176cdab6138a05ca9ee5ca393b3efd3f16a62e0967bb" => :sierra
    sha256 "1018bd6c084dc07012e01993e8f7699d5ecc1df1c09a69150bc264c2dca4bc91" => :el_capitan
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
