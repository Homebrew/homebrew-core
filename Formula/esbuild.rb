require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.12.tgz"
  sha256 "d475d26fae510eb9aa0eae171bc55cc745f11632db8c2a7ac696501ec3f5f24c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "185644efd2d788893dcbbc0f50ae9f6aa8fe1cf3e86e0e284e3dc2a05e812ec9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "185644efd2d788893dcbbc0f50ae9f6aa8fe1cf3e86e0e284e3dc2a05e812ec9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "185644efd2d788893dcbbc0f50ae9f6aa8fe1cf3e86e0e284e3dc2a05e812ec9"
    sha256 cellar: :any_skip_relocation, ventura:        "4efbfd4864fbd23b74efbdae6179dca93a4749ef9d4f4b4ed0529bf5a288a284"
    sha256 cellar: :any_skip_relocation, monterey:       "4efbfd4864fbd23b74efbdae6179dca93a4749ef9d4f4b4ed0529bf5a288a284"
    sha256 cellar: :any_skip_relocation, big_sur:        "4efbfd4864fbd23b74efbdae6179dca93a4749ef9d4f4b4ed0529bf5a288a284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c836e1af369c3d46d0e40a829366dbb0891b77e28caeed1ee91537182677c11"
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
