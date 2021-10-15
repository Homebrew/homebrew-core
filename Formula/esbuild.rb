require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.7.tgz"
  sha256 "efdbe9156bae864fe7c9d909984f5c955d05e1ab18adce6d15cad1a0e8ff02af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77e7711d50719ee567b9f00a2fd1f44cb2ccd61c965244d7000f0f26b8e0d6cd"
    sha256 cellar: :any_skip_relocation, big_sur:       "7150b804f58cec34d2d6d93baa9d3541a4f77884a470b2523a0ac4dfde74c426"
    sha256 cellar: :any_skip_relocation, catalina:      "7150b804f58cec34d2d6d93baa9d3541a4f77884a470b2523a0ac4dfde74c426"
    sha256 cellar: :any_skip_relocation, mojave:        "7150b804f58cec34d2d6d93baa9d3541a4f77884a470b2523a0ac4dfde74c426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f80967ed0b27f6899f9769d923c8c1c3bee8cb229dcc78ec3d8ad1e53bac9de7"
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
