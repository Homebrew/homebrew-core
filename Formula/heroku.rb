require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.6.0.tgz"
  sha256 "250f64b81d6895a5aa3ccd394dc1295f79132d8b4a26243363bf6ea9d1927c8d"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1915ef8d9208a6bf18ebfae992347d7e9cf9a0b7e94cbd0263b9b8919d0821ae" => :high_sierra
    sha256 "09a844cf367eaaa24146eb866abc6e510b53f281ffaba09131ac3fe79e33828c" => :sierra
    sha256 "10e582480f728e2fb2c2e8b73e9fefa2ecf3c8bb59ad693c59fc264d51efc1cf" => :el_capitan
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
