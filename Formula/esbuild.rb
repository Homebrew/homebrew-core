require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.8.tgz"
  sha256 "5244b28ac66313139493891d1b9033713fe9f1bbd25fe574388fd13a427d9889"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "290e56f3f4b4caaf5b52c37412e46d597cfb1e1856bafa071cdb2c74fdd99de9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "290e56f3f4b4caaf5b52c37412e46d597cfb1e1856bafa071cdb2c74fdd99de9"
    sha256 cellar: :any_skip_relocation, monterey:       "adbefefa25fe43bf9f94ccf9414ee0a6de533f969fd4f7cdbcdacd022e6ca707"
    sha256 cellar: :any_skip_relocation, big_sur:        "adbefefa25fe43bf9f94ccf9414ee0a6de533f969fd4f7cdbcdacd022e6ca707"
    sha256 cellar: :any_skip_relocation, catalina:       "adbefefa25fe43bf9f94ccf9414ee0a6de533f969fd4f7cdbcdacd022e6ca707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba3f29def2a26721b12dbd12df531540d71d15ddae697c48235ab268654de38"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.jsx").write <<~EOS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
    EOS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
