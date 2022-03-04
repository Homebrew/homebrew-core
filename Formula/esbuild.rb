require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.25.tgz"
  sha256 "e5e2a6f3bd6162c35342d86e29b617c3140118efcc28e5bd0fb97ff10a0d7d4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb3ece2f581c8c869198fd45558eee8694d71d3d308223ccee6ff2c5becb088"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afb3ece2f581c8c869198fd45558eee8694d71d3d308223ccee6ff2c5becb088"
    sha256 cellar: :any_skip_relocation, monterey:       "92f030ea49c7bc9524f1bc97d0df04616276feb5c6e85d63e56edd59e3635c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "92f030ea49c7bc9524f1bc97d0df04616276feb5c6e85d63e56edd59e3635c68"
    sha256 cellar: :any_skip_relocation, catalina:       "92f030ea49c7bc9524f1bc97d0df04616276feb5c6e85d63e56edd59e3635c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d6e9124df8d50e74fcd37e74f66076e5d94cb61daf8e90e08ec69128c72c194"
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
