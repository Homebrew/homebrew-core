require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.11.tgz"
  sha256 "eb24708a3c28f1f882bf12778c29aecaa5fcdb91cc378c130b39a07ed46f7034"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3a8719239f77cf04e838d44895a1d40add01cd528b65e47ef3444d8ed5d260e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3a8719239f77cf04e838d44895a1d40add01cd528b65e47ef3444d8ed5d260e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3a8719239f77cf04e838d44895a1d40add01cd528b65e47ef3444d8ed5d260e"
    sha256 cellar: :any_skip_relocation, ventura:        "cdf2a95abf7f3180132ddf51e0f8469a4af33cc2409f3863c0c0168dd9c4488e"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf2a95abf7f3180132ddf51e0f8469a4af33cc2409f3863c0c0168dd9c4488e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdf2a95abf7f3180132ddf51e0f8469a4af33cc2409f3863c0c0168dd9c4488e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72e86d6963201b7066ee49a95d51fc012a70f277e87912eff8290e22ef82565a"
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
