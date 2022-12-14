require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.7.tgz"
  sha256 "ad2fc674788265b96628d8089fd90f764a05552cfe50522db07237969770bed0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41bd1fbdde89ced3b4c86d71533bc34cdec4ca869fff4bfb07e9de3df901d522"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41bd1fbdde89ced3b4c86d71533bc34cdec4ca869fff4bfb07e9de3df901d522"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41bd1fbdde89ced3b4c86d71533bc34cdec4ca869fff4bfb07e9de3df901d522"
    sha256 cellar: :any_skip_relocation, ventura:        "d4778e12d9cb1f750be8ca8e9b53b156eb94b849c6afa1b875fb3d55ac5da179"
    sha256 cellar: :any_skip_relocation, monterey:       "d4778e12d9cb1f750be8ca8e9b53b156eb94b849c6afa1b875fb3d55ac5da179"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4778e12d9cb1f750be8ca8e9b53b156eb94b849c6afa1b875fb3d55ac5da179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24649cfc816a7a17e47c413f20b4a83133b253fe225fe90eccd7d872779654e9"
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
