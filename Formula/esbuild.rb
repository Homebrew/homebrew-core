require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.18.tgz"
  sha256 "ede365bc46bfd49b80677955b56a4fbeb6c4b50f187cece83d3b99b39cf1f0b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12bac1c42ed05ee7e157e9c63002c3aaf077a27da2a7e587f4396c50b1e66f1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12bac1c42ed05ee7e157e9c63002c3aaf077a27da2a7e587f4396c50b1e66f1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12bac1c42ed05ee7e157e9c63002c3aaf077a27da2a7e587f4396c50b1e66f1d"
    sha256 cellar: :any_skip_relocation, ventura:        "7e8e8446ff3b532588208c94ebe17dc76edb59190ea23059a0943e48d7de196b"
    sha256 cellar: :any_skip_relocation, monterey:       "7e8e8446ff3b532588208c94ebe17dc76edb59190ea23059a0943e48d7de196b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e8e8446ff3b532588208c94ebe17dc76edb59190ea23059a0943e48d7de196b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f6be3aa3c20d640a49cbfc3305a3e9347d74de64067fc126e18455099d24ef2"
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
