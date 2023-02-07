require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.6.tgz"
  sha256 "83d1c6f4b2b3c9b5ad6d5d97f5f3ee91fa8aaedd3e5b4a90e7edd13db3b168c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22e4e9dfab7464e2954116dc875f6ec6c983620a794a4fa4facb9c6734b97901"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22e4e9dfab7464e2954116dc875f6ec6c983620a794a4fa4facb9c6734b97901"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22e4e9dfab7464e2954116dc875f6ec6c983620a794a4fa4facb9c6734b97901"
    sha256 cellar: :any_skip_relocation, ventura:        "87c1fd70e48905f35d364e5e1bf590b52c3128753fa2c3cf4a75391f0a5d7723"
    sha256 cellar: :any_skip_relocation, monterey:       "87c1fd70e48905f35d364e5e1bf590b52c3128753fa2c3cf4a75391f0a5d7723"
    sha256 cellar: :any_skip_relocation, big_sur:        "87c1fd70e48905f35d364e5e1bf590b52c3128753fa2c3cf4a75391f0a5d7723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "845c2fa5ae7e38adfcb41a0b2d1dfdcc43eb7b6a4fae8e0de648076721c89eb4"
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
