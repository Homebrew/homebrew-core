require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.30.tgz"
  sha256 "a16bdc2e825ec41b6a3da57e9dc483ce90e37564173ae2c0d0ef4e622659bb7e"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d03604c0089e3d3ece018429c2451018f2cc493cd760f52f6fabda8e0b111bf" => :high_sierra
    sha256 "b343cff6738f27346eb4a387b95dcc8f3ccc887864300f91eb112843dc55f491" => :sierra
    sha256 "d8df42adb381d9f3baf44af3fb0aee688a8cc32eef41032ba824fa972b14070f" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run", "#!/usr/bin/env node",
                         "#!#{Formula["node"].opt_bin}/node"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
