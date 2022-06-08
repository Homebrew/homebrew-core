require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.43.tgz"
  sha256 "e540e14d1f0f0ae357074b47245c33a2c92f698b450332f1d547eb5c67447961"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7809c5ad20c9856c7ab05c0cad6fb22ceef484ad2563b3826b23b3a53fbbba34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7809c5ad20c9856c7ab05c0cad6fb22ceef484ad2563b3826b23b3a53fbbba34"
    sha256 cellar: :any_skip_relocation, monterey:       "97794d6cf3f72ee3bcb8c463b83335ee4778a114995a776b3fd35a1bba91bb45"
    sha256 cellar: :any_skip_relocation, big_sur:        "97794d6cf3f72ee3bcb8c463b83335ee4778a114995a776b3fd35a1bba91bb45"
    sha256 cellar: :any_skip_relocation, catalina:       "97794d6cf3f72ee3bcb8c463b83335ee4778a114995a776b3fd35a1bba91bb45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eaeb9f59397714027c3b2a5c283eeb6b02e948cf511b879d23684fdc8a10ab4"
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
