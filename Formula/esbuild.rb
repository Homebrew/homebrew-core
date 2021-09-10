require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.12.26.tgz"
  sha256 "59e3b5d0e47bf57177bacde40711ab4ee872b17b6edcaf8ce9522960c7ea65b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca86980ae01cf0a611a5d8f72672e21cc848234cbdacc30851794cb499c81f22"
    sha256 cellar: :any_skip_relocation, big_sur:       "b196ef99aed174592c4d8503a06dafdeae8aaa4b7d006b9cbebe51438970ad9f"
    sha256 cellar: :any_skip_relocation, catalina:      "b196ef99aed174592c4d8503a06dafdeae8aaa4b7d006b9cbebe51438970ad9f"
    sha256 cellar: :any_skip_relocation, mojave:        "b196ef99aed174592c4d8503a06dafdeae8aaa4b7d006b9cbebe51438970ad9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2be47aa72f7fce852e8b9a3e4b58c734b891e92433725a61ebd33daeb95d17e8"
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
