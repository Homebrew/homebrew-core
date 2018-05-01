require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.21.tgz"
  sha256 "cb3fa5ce2b1b408358f831358fdb7f16728a9e3f63bff4e3f5ff40b45e9d6323"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bb75956d39f3008bc35036b1ae64294709c2dc6dc34e28bae3ab2269d6874d9" => :high_sierra
    sha256 "9e17f0328227c748ae42fac92892f22ca19abfc53541380ea3a3f988c4d13698" => :sierra
    sha256 "8117c4f133290cb2bd416458c4d1e33d62cd7721a2e6b87e64c4c721ace04365" => :el_capitan
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
