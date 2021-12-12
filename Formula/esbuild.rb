require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.3.tgz"
  sha256 "2d57dbbb35f6fb49efc9d7b63b8272cb5049c47fe8fe5af82c2da2152759a243"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31cc0e375634b023130301a254c505987c7deb4d71321d9a0adea92211603bf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31cc0e375634b023130301a254c505987c7deb4d71321d9a0adea92211603bf7"
    sha256 cellar: :any_skip_relocation, monterey:       "1a4fcf37d7857bdffa0151ca5045f5afcc60f431e525e930608b4cac2a044294"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a4fcf37d7857bdffa0151ca5045f5afcc60f431e525e930608b4cac2a044294"
    sha256 cellar: :any_skip_relocation, catalina:       "1a4fcf37d7857bdffa0151ca5045f5afcc60f431e525e930608b4cac2a044294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51c7cbce912b3ba90f29a2eb68a2e07f584583d1f6970c27fce5feeef7fb394c"
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
