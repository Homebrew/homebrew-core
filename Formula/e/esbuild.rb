require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.20.0.tgz"
  sha256 "c1f79e6fc30985c69c8b27f075a41a447f0b7da350cc49aa42ba4fa3bba89006"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6e2a77ab0d94f0244aaf042f2b60d82d4ae8391eec5f70d1e6db63280444508"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6e2a77ab0d94f0244aaf042f2b60d82d4ae8391eec5f70d1e6db63280444508"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6e2a77ab0d94f0244aaf042f2b60d82d4ae8391eec5f70d1e6db63280444508"
    sha256 cellar: :any_skip_relocation, sonoma:         "498179b2ad12dc2c3a982b580931b7f6e3a6f9408805bdf4a5e63b6ed74fd989"
    sha256 cellar: :any_skip_relocation, ventura:        "498179b2ad12dc2c3a982b580931b7f6e3a6f9408805bdf4a5e63b6ed74fd989"
    sha256 cellar: :any_skip_relocation, monterey:       "498179b2ad12dc2c3a982b580931b7f6e3a6f9408805bdf4a5e63b6ed74fd989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a6718d5695058bf1f55eeb627018b0d9bb2efd77f35ca9c53549a9342ce0762"
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
