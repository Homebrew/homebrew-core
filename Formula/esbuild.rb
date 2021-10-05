require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.4.tgz"
  sha256 "8b1f289315c72de548868ecab7517e2da0504ab72aefd64b16c845662f54fdf2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "673800245483c16c8b509f3d47fbf4c85b93bb280b062e295fa8ea75760c48d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "9453604779a422f8d8bb419d311d12b730953feb6d9ea89f9ddabf121d336ac9"
    sha256 cellar: :any_skip_relocation, catalina:      "9453604779a422f8d8bb419d311d12b730953feb6d9ea89f9ddabf121d336ac9"
    sha256 cellar: :any_skip_relocation, mojave:        "9453604779a422f8d8bb419d311d12b730953feb6d9ea89f9ddabf121d336ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36dae83644c833255375456c575fd6ce3613099ab46fb2ac9aba0ae76c8c7210"
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
