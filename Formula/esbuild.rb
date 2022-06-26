require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.47.tgz"
  sha256 "f530bd96008a41f7f571c6f39c8b5e13f6ff5da47daf303e56834c9a8f2930be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad6cf3742198428ad66c8156e154e4f7f85c3a3d8d3959ec05fe2fa5880c9901"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad6cf3742198428ad66c8156e154e4f7f85c3a3d8d3959ec05fe2fa5880c9901"
    sha256 cellar: :any_skip_relocation, monterey:       "26b632a7e820426f3bc25256281a7e42371bdf0c42a76d4c06987c40d2466de7"
    sha256 cellar: :any_skip_relocation, big_sur:        "26b632a7e820426f3bc25256281a7e42371bdf0c42a76d4c06987c40d2466de7"
    sha256 cellar: :any_skip_relocation, catalina:       "26b632a7e820426f3bc25256281a7e42371bdf0c42a76d4c06987c40d2466de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8813116a27b96bfd90815bdee7dff60be6fa4630c88fdc09c1692f5822478b6f"
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
