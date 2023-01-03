require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.13.tgz"
  sha256 "7d84a3a3c7954706de5c0d596c61b9d18e1fb0d72ce8c534f09886c3ce6cc2a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f14e6b2f0c5d87a66aa4d7cb36e41959b026405504889c59aac4fd8a994e4f5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f14e6b2f0c5d87a66aa4d7cb36e41959b026405504889c59aac4fd8a994e4f5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f14e6b2f0c5d87a66aa4d7cb36e41959b026405504889c59aac4fd8a994e4f5c"
    sha256 cellar: :any_skip_relocation, ventura:        "5329cd176dd3116f65f64a65d8ef7963d906df5db7ed46464b5ad1821dae2739"
    sha256 cellar: :any_skip_relocation, monterey:       "5329cd176dd3116f65f64a65d8ef7963d906df5db7ed46464b5ad1821dae2739"
    sha256 cellar: :any_skip_relocation, big_sur:        "5329cd176dd3116f65f64a65d8ef7963d906df5db7ed46464b5ad1821dae2739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f604cd95cfa49b2d28e1364882df7ed7bd46361f9f530e7bc91f675f273bdf"
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
