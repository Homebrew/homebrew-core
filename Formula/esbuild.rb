require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.26.tgz"
  sha256 "69ab196aa8b491e47d6ddfe61343062f802ab6bed9f80a876bbde97108833e39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e250bfb4cccf04512fc5459722a24ff418517a9b5dbbd169c5ebc17ba842c9d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e250bfb4cccf04512fc5459722a24ff418517a9b5dbbd169c5ebc17ba842c9d1"
    sha256 cellar: :any_skip_relocation, monterey:       "a5da803db13c7d85748ddce8d0481898bbef8f9c92f0beb44375cf06b42ebebc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5da803db13c7d85748ddce8d0481898bbef8f9c92f0beb44375cf06b42ebebc"
    sha256 cellar: :any_skip_relocation, catalina:       "a5da803db13c7d85748ddce8d0481898bbef8f9c92f0beb44375cf06b42ebebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e58cdbc468e8a8f066f67c5fe87b108c6bdb92eea3d3c0e7fd19f9ef27178358"
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
