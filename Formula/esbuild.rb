require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.0.tgz"
  sha256 "ee1cda1d90c33d0df509d626aa927cfe1a54a00b6e05a70a839413b6a1c138a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f231fedc26d8a7473d3eb43c35b006b1b6477da7968b8da35ac0249cfb129c07"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3d5c998f94adfa817bee22ab11bb4da0d3ed9697efa5bbb7de9c088461dc401"
    sha256 cellar: :any_skip_relocation, catalina:      "b3d5c998f94adfa817bee22ab11bb4da0d3ed9697efa5bbb7de9c088461dc401"
    sha256 cellar: :any_skip_relocation, mojave:        "b3d5c998f94adfa817bee22ab11bb4da0d3ed9697efa5bbb7de9c088461dc401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566e41b059e0a5d2be67b8f7315ac4a451bff32c3e142be91442f8bb463f26ce"
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
