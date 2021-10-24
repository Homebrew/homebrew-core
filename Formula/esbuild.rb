require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.9.tgz"
  sha256 "020ae85ea9712faebce7d4d6c30fc21de70fcd3b2005f038d6a14ae62382ed1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b85f00982cfa5f1e25965974b662a9635fbeb3ce3c33ed26b3bcba3c87ff3efa"
    sha256 cellar: :any_skip_relocation, big_sur:       "cba0fc0726a6225ed7100a106f2efd2caabe907d25cf32cc525f78968fac5c34"
    sha256 cellar: :any_skip_relocation, catalina:      "cba0fc0726a6225ed7100a106f2efd2caabe907d25cf32cc525f78968fac5c34"
    sha256 cellar: :any_skip_relocation, mojave:        "cba0fc0726a6225ed7100a106f2efd2caabe907d25cf32cc525f78968fac5c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84fe5c56b7db0d6583e1fc23b0694e4ef67e916bef0dd5ae4ec107eff1a894f6"
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

    assert_equal "<h1 data-reactroot=\"\">Hello, world!</h1>\n", shell_output("node out.js")
  end
end
