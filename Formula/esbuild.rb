require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.10.tgz"
  sha256 "1736ca91c69cff277bf1081f82ada72263f045acb6fc536988c501b868203cc8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a6606b465fb43b12bc1333896a17784a3f15cfa7a98232a02f8ef256f8fdb80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a6606b465fb43b12bc1333896a17784a3f15cfa7a98232a02f8ef256f8fdb80"
    sha256 cellar: :any_skip_relocation, monterey:       "ead0898bf17bc204533fcda8772844f89a972452f910c57910eeb9d32d423318"
    sha256 cellar: :any_skip_relocation, big_sur:        "ead0898bf17bc204533fcda8772844f89a972452f910c57910eeb9d32d423318"
    sha256 cellar: :any_skip_relocation, catalina:       "ead0898bf17bc204533fcda8772844f89a972452f910c57910eeb9d32d423318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7121ec068f6449dd85dbc0df9b20a4fc4296a015710af6f9d1b9ae55ec9840f"
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
