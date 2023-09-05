require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.2.tgz"
  sha256 "b4bb57c99004de841ea746b0a999274d5486e63b209c3ba45e11da51b913f7bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "208ec1660c9a344b7b0d67c310690720f374c7fad2114c0340def81310b8cba0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "208ec1660c9a344b7b0d67c310690720f374c7fad2114c0340def81310b8cba0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "208ec1660c9a344b7b0d67c310690720f374c7fad2114c0340def81310b8cba0"
    sha256 cellar: :any_skip_relocation, ventura:        "cff9235224751033d393ac93a2bb0fccf8bffdaaa38f5e89fdb99fd03b2f53fb"
    sha256 cellar: :any_skip_relocation, monterey:       "cff9235224751033d393ac93a2bb0fccf8bffdaaa38f5e89fdb99fd03b2f53fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "cff9235224751033d393ac93a2bb0fccf8bffdaaa38f5e89fdb99fd03b2f53fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b98c769c6e0d82d21f9989cd65f06201118000d64c86e21f2f230168655fc62"
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
