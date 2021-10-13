require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.5.tgz"
  sha256 "c2eb414231ba94ac6458b89dc264cb702f07864f59a09e8258836c61506ed9f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2832ae8c704096a89029cb117406727cdcd4c2ffad50c4d5cf735a57022aeb60"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5f4fbf8b350a52235df1c87affd534a014147738c4e580f0705678ad41573cc"
    sha256 cellar: :any_skip_relocation, catalina:      "f5f4fbf8b350a52235df1c87affd534a014147738c4e580f0705678ad41573cc"
    sha256 cellar: :any_skip_relocation, mojave:        "f5f4fbf8b350a52235df1c87affd534a014147738c4e580f0705678ad41573cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb4c463312fd9d1ebd03dd2b125d13dd44e5f9d22b0163b9186b9e8e0d232fa"
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
