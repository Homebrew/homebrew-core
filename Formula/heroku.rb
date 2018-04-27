require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.16.tgz"
  sha256 "9c46e8dfebe510b568278031a220e02b50985e618f58e569ce7c519b1172b1ee"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae6f14bd866823b936ac8ec4e15a2aa9c5a5b20ae535151b9ea252d7c3261af1" => :high_sierra
    sha256 "b9c204e493c6fa3500bfedf3f73d628d3364b3f37b7cc496de356a7eda1874d1" => :sierra
    sha256 "552fb11986555470442bdbb71d0654b5bb6131d4e96f03d69f546100cc457d77" => :el_capitan
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
