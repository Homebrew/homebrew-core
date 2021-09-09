require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.12.26.tgz"
  sha256 "59e3b5d0e47bf57177bacde40711ab4ee872b17b6edcaf8ce9522960c7ea65b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf25af8aae91701f5341420871f51c5d137e105b9417448c65d49232c7f6d972"
    sha256 cellar: :any_skip_relocation, big_sur:       "67d11d694fd6b626402c61eda953cd828df3cf9fc5bf0d8e4936f0dc3322136a"
    sha256 cellar: :any_skip_relocation, catalina:      "67d11d694fd6b626402c61eda953cd828df3cf9fc5bf0d8e4936f0dc3322136a"
    sha256 cellar: :any_skip_relocation, mojave:        "67d11d694fd6b626402c61eda953cd828df3cf9fc5bf0d8e4936f0dc3322136a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "282cef546339d927fe11d30c22d648972c50226dcdf532dfe25c1def679243bd"
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
