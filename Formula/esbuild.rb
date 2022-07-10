require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.49.tgz"
  sha256 "4bf7f5fdee4568b517536a929bea54d56042b574a695fc929b23bf12c53ae49e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "783c9de6839b082bbe57d553fac2e7df5d3672d9dd276cfb12a59e04f0b7baa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "783c9de6839b082bbe57d553fac2e7df5d3672d9dd276cfb12a59e04f0b7baa2"
    sha256 cellar: :any_skip_relocation, monterey:       "549fe4e7b79bc72b7290c65ae2a28548f2596b2cc907912061d1bf8f68ae1307"
    sha256 cellar: :any_skip_relocation, big_sur:        "549fe4e7b79bc72b7290c65ae2a28548f2596b2cc907912061d1bf8f68ae1307"
    sha256 cellar: :any_skip_relocation, catalina:       "549fe4e7b79bc72b7290c65ae2a28548f2596b2cc907912061d1bf8f68ae1307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "808451fd685e934926f4b34150edf38fe6ef17e606c5001ca9d00bf268352c14"
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
