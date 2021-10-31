require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.11.tgz"
  sha256 "129dab40c2df91e62a7086a1417c54ebafa0eb3316d86a91b8eb7ede0e9c694c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec31fcdef11efa059fec31b218f13b680bceff1b9dc1e474768c243b2fcf76a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec31fcdef11efa059fec31b218f13b680bceff1b9dc1e474768c243b2fcf76a9"
    sha256 cellar: :any_skip_relocation, monterey:       "284d52501a9f2000c1408e6e2d40883da139ca3065c9a499bb0585c5ddbca700"
    sha256 cellar: :any_skip_relocation, big_sur:        "284d52501a9f2000c1408e6e2d40883da139ca3065c9a499bb0585c5ddbca700"
    sha256 cellar: :any_skip_relocation, catalina:       "284d52501a9f2000c1408e6e2d40883da139ca3065c9a499bb0585c5ddbca700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09f447192330a3d1d38a3c56c94a446263f1118b8bc061e6fe19a2c0c3dbbb66"
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
