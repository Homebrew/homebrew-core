require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.8.tgz"
  sha256 "2f87435da93d5af68bee4f8197a35c993abcaf3b175dc157152b464a3d21233c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1d7ed9fb891aed05487eb5df7e45c45efa76ef91c3252c60ca0361ac5afcafb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdfe11d441f66f54b13cac130ec740628ccc34e66a16dee194e12e4292d70bee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55ee270801b44a53533c67b028db96b0c6f5d10a85414a40fdf1ca19dc753b62"
    sha256 cellar: :any_skip_relocation, ventura:        "bd6fa5493c557960de6e4022bda8b41c90c7891989ffc35cf630b3dc09f45fa4"
    sha256 cellar: :any_skip_relocation, monterey:       "4931336ad6cb2da25f489e2e76dad1b1d4a5018ccf6a663a6b97d5dc48a4a60b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b2839c5cc7bc4284af548606a6b6bafd2d17c3c665b2c5b024cba310c662be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f015ef94461521683e58bd9502cd076d9c6a676b854638b70045944a1df40ffe"
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
