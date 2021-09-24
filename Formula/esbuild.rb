require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.2.tgz"
  sha256 "77432a045f48e43d6c255eb026ee4f4f8d5dd4b540297f4b670acc18a153b9ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "69d376a45993965ae9059eb6f377a62e150c4a02d0b53c509c674223a3827c61"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b259604d1546ea930ca05f28d821588e2a3ecb3671f6c0abe25a22052959ec9"
    sha256 cellar: :any_skip_relocation, catalina:      "4b259604d1546ea930ca05f28d821588e2a3ecb3671f6c0abe25a22052959ec9"
    sha256 cellar: :any_skip_relocation, mojave:        "4b259604d1546ea930ca05f28d821588e2a3ecb3671f6c0abe25a22052959ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd60baf86e8ee841b77aace25e9946aca2e5b290e80526633e1f6530b62d371e"
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
