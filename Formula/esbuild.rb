require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.36.tgz"
  sha256 "415e5361f97d1a663fbeabca356d5583442790ffb0c91c4e25e0541234722af9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f241d76a7de3a93cebb144784e071270227ac767c6e8d152786c58084696c7be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f241d76a7de3a93cebb144784e071270227ac767c6e8d152786c58084696c7be"
    sha256 cellar: :any_skip_relocation, monterey:       "e7dc9bd143ad3c5d0dc14f96b699b090bb31c404b61cf72256c201b12ac60e30"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7dc9bd143ad3c5d0dc14f96b699b090bb31c404b61cf72256c201b12ac60e30"
    sha256 cellar: :any_skip_relocation, catalina:       "e7dc9bd143ad3c5d0dc14f96b699b090bb31c404b61cf72256c201b12ac60e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "734154fe48854e437e3fc012ed5b24d068bf8a22968bc9a81d954ef570d6bd64"
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
