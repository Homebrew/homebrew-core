require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.9.3.tgz"
  sha256 "b107035222a6ed50306a4d960d643a6f5462241d90a4fcfeb71d1d4ae431156b"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c829f8a8f7ef0ceeee7e74f8be246d79068fcd17fe0642fae39138e5a9950be" => :high_sierra
    sha256 "084c3c7b276058ee040614013fa732a0eceab9ec1364f2afb2ac85172845677c" => :sierra
    sha256 "a4b0d608feff126f01d7118ee7cd306d74f10956ec9894d7200eba7de2b91d6d" => :el_capitan
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
