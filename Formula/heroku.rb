require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  # heroku should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.80.tgz"
  sha256 "510fe89398ba7e21fd6d12e4796e6b45edeff8d6118dac996b5a51453d87eae8"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d60789e5a9915a92cf09762f92b785ddd5324ceba13ee8637c709dd56712bfa2" => :high_sierra
    sha256 "15e803496835dacc78806c04b9ba87f8f622073bca854604ee70fe87e115ac6f" => :sierra
    sha256 "aca10615c4b697af8f52fff16a1b2546481341382be6f43c7b1a0393815d323f" => :el_capitan
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
