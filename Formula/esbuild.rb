require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.10.tgz"
  sha256 "eb62168dfef36fb44131fa4c8fa4f5d006d6699c3a541414b44a95f75a1d1cdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9359555783fa0c599609f0e8579e8d1b0322f9108cc19707cda5bd379a64874"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9359555783fa0c599609f0e8579e8d1b0322f9108cc19707cda5bd379a64874"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9359555783fa0c599609f0e8579e8d1b0322f9108cc19707cda5bd379a64874"
    sha256 cellar: :any_skip_relocation, ventura:        "e7bb862229c899e5864319709c6caa29d2fa62fbf769c24664e22678140f36a3"
    sha256 cellar: :any_skip_relocation, monterey:       "e7bb862229c899e5864319709c6caa29d2fa62fbf769c24664e22678140f36a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7bb862229c899e5864319709c6caa29d2fa62fbf769c24664e22678140f36a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "302d533fae66d72c892b82eec8b795986ff877d96e3510d63c744f5093cb9ae9"
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
