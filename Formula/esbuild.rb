require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.21.tgz"
  sha256 "6933ccc42e8ba85e858ff5ebc888b68d32982f129a2f4e2af0a46d0b953a3177"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9367fdbe737b2cb14abd11fafacdaf208612c0b9c8c8839d43868fa309a36a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9367fdbe737b2cb14abd11fafacdaf208612c0b9c8c8839d43868fa309a36a5"
    sha256 cellar: :any_skip_relocation, monterey:       "deaa0421ebcfefae7c8156c3b0e6e2ab117f3d3158cbb11c5eff2d0c2cdca945"
    sha256 cellar: :any_skip_relocation, big_sur:        "deaa0421ebcfefae7c8156c3b0e6e2ab117f3d3158cbb11c5eff2d0c2cdca945"
    sha256 cellar: :any_skip_relocation, catalina:       "deaa0421ebcfefae7c8156c3b0e6e2ab117f3d3158cbb11c5eff2d0c2cdca945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1273e8c4ba2131434017e69790cff737a31a02de3d6b32ecab22978c525f9f"
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
