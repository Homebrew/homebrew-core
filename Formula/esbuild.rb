require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.7.tgz"
  sha256 "b363c871f0c16a1fb6695f223dcc433f2f173885e6fe5adde51572f5276967ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54b52df543a75cd0146194678af47af8779e231b5a7038a4027f4c95fa7dff58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54b52df543a75cd0146194678af47af8779e231b5a7038a4027f4c95fa7dff58"
    sha256 cellar: :any_skip_relocation, monterey:       "d1b21774a92c3ba9421e9df3f07f27bd7e2da9e524d77f8a32aab2032f45a0ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1b21774a92c3ba9421e9df3f07f27bd7e2da9e524d77f8a32aab2032f45a0ba"
    sha256 cellar: :any_skip_relocation, catalina:       "d1b21774a92c3ba9421e9df3f07f27bd7e2da9e524d77f8a32aab2032f45a0ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e7575db8237e00045339f4c460a0db49681cc6902f0984993d24310619fe32"
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
