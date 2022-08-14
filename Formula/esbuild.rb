require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.3.tgz"
  sha256 "dbeca25348b51f9148499c4b69ac208b257179551b2019540f7d2a8c0f74556d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0caa107b724e431ede657aa10eb0801e3ff640aedc3880bc7e187dc368746f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0caa107b724e431ede657aa10eb0801e3ff640aedc3880bc7e187dc368746f5a"
    sha256 cellar: :any_skip_relocation, monterey:       "ee813bb9d6a61f23cba6a7fe5f6f1791bb78ec2b2045f343fc70ad1f17365f7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee813bb9d6a61f23cba6a7fe5f6f1791bb78ec2b2045f343fc70ad1f17365f7b"
    sha256 cellar: :any_skip_relocation, catalina:       "ee813bb9d6a61f23cba6a7fe5f6f1791bb78ec2b2045f343fc70ad1f17365f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a33a55811bd87641a0821b62e3c475ec6222759b29bc5dde43aa6f8a443821"
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
