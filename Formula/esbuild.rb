require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.51.tgz"
  sha256 "5006dd43561bea9ba258188ae063c3a09553ad4bead4874ee867cc9b43765970"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1fcff1a612935c7c00beddd0e7e8852bfdda1b0870bcdf7ddb6e758a25c3d2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1fcff1a612935c7c00beddd0e7e8852bfdda1b0870bcdf7ddb6e758a25c3d2d"
    sha256 cellar: :any_skip_relocation, monterey:       "2543bdf5c3d8903c2f3a0447270924b33ae73a6a97c1ed5f66e9f4b8b3a20c96"
    sha256 cellar: :any_skip_relocation, big_sur:        "2543bdf5c3d8903c2f3a0447270924b33ae73a6a97c1ed5f66e9f4b8b3a20c96"
    sha256 cellar: :any_skip_relocation, catalina:       "2543bdf5c3d8903c2f3a0447270924b33ae73a6a97c1ed5f66e9f4b8b3a20c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7357465f7b8ff5af72456ea14d97ebbf53fee1e6af52b20d951d45af19ba4204"
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
