require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.1.tgz"
  sha256 "1cee1529b3337290dfddfe859ed7231700fbd21260f67159c73d146e6c01113e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a05a7dc07b375bbf3760057a85f6ab69888f1634bf519dffad61a7528946e69f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a05a7dc07b375bbf3760057a85f6ab69888f1634bf519dffad61a7528946e69f"
    sha256 cellar: :any_skip_relocation, monterey:       "22c9273783b2b2037ef77a537365b78c2c13f67150112665fe23e081b0181881"
    sha256 cellar: :any_skip_relocation, big_sur:        "22c9273783b2b2037ef77a537365b78c2c13f67150112665fe23e081b0181881"
    sha256 cellar: :any_skip_relocation, catalina:       "22c9273783b2b2037ef77a537365b78c2c13f67150112665fe23e081b0181881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8e73e6bb3315fa0081a3971a849d1e01d7426a029d55f3915186b84a8ebc694"
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
