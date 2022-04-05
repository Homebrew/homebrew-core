require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.31.tgz"
  sha256 "85061fc99110cdb00ef39611c18fd3119c7dae49923a0ffd44c6457b74dea963"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2495bcee2ceb88351dabb7f0d9608a4dba198db08c5c89ee4ba933bca6f288b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2495bcee2ceb88351dabb7f0d9608a4dba198db08c5c89ee4ba933bca6f288b6"
    sha256 cellar: :any_skip_relocation, monterey:       "8e3d2825f80aa29c54258b166481b4034e3d54c0e52428face947176031fc0e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e3d2825f80aa29c54258b166481b4034e3d54c0e52428face947176031fc0e4"
    sha256 cellar: :any_skip_relocation, catalina:       "8e3d2825f80aa29c54258b166481b4034e3d54c0e52428face947176031fc0e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cfa7b4e88e481b10e37291032f3c770267d0d62906e9b9272c46900dbd4468f"
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
