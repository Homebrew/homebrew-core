require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.14.tgz"
  sha256 "5adf968e0b823f603c88a18201fe81e538f1c6b0e8b1db9c62c1f0b232ff560d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "740467c54deadb32547b680e9927013b48e003747453e0e86375029fd3d00355"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "740467c54deadb32547b680e9927013b48e003747453e0e86375029fd3d00355"
    sha256 cellar: :any_skip_relocation, monterey:       "4bd8cfbd9521a833cce52cb8f6023e146e717f64b69b5ce798a3ecb00f41791c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bd8cfbd9521a833cce52cb8f6023e146e717f64b69b5ce798a3ecb00f41791c"
    sha256 cellar: :any_skip_relocation, catalina:       "4bd8cfbd9521a833cce52cb8f6023e146e717f64b69b5ce798a3ecb00f41791c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9104fe51f488d276110f44890c36c47f2fdace1251d9cb96d3690722d8a49b7c"
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
