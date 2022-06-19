require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.46.tgz"
  sha256 "14e5193767ce1f22e5becc4736546192c0ad44530990deaa3c1e2c3777620450"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1b8c376353f9044e1121b6fe725d17aeff9d12a0b2a33f492cdd7830b9cc0a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1b8c376353f9044e1121b6fe725d17aeff9d12a0b2a33f492cdd7830b9cc0a5"
    sha256 cellar: :any_skip_relocation, monterey:       "01e0382515cc6a0abf536e140831127d1630e53567cf78b890fc4a691de6c57d"
    sha256 cellar: :any_skip_relocation, big_sur:        "01e0382515cc6a0abf536e140831127d1630e53567cf78b890fc4a691de6c57d"
    sha256 cellar: :any_skip_relocation, catalina:       "01e0382515cc6a0abf536e140831127d1630e53567cf78b890fc4a691de6c57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b263fff0bed03dce9307b803132fa22f22be2a00cad853488f0a24d4c17ad231"
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
