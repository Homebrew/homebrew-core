require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.0.tgz"
  sha256 "0abbdec55947718a3b1f129b91b01f4ffc28a7308019f82f78bdb4867e92cdff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a634f21e3f124e794f1e0f78db772f1fa6360e2c352c63466a02a21eb170ffaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a634f21e3f124e794f1e0f78db772f1fa6360e2c352c63466a02a21eb170ffaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a634f21e3f124e794f1e0f78db772f1fa6360e2c352c63466a02a21eb170ffaa"
    sha256 cellar: :any_skip_relocation, ventura:        "08fe9caef7679e5c6fc27f3c98415f5a38a66b5d0b4bc03e4b34dc7c56a26577"
    sha256 cellar: :any_skip_relocation, monterey:       "08fe9caef7679e5c6fc27f3c98415f5a38a66b5d0b4bc03e4b34dc7c56a26577"
    sha256 cellar: :any_skip_relocation, big_sur:        "08fe9caef7679e5c6fc27f3c98415f5a38a66b5d0b4bc03e4b34dc7c56a26577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77a0e78304ef27d4f8b36104919083578b67f48ddff67997de7efb6b2054c501"
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
