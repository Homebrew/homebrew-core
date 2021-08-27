require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.12.24.tgz"
  sha256 "1b0c55686e25fbe648118f5ef62360f2582c48d384d56dbe956d3b6f45b8497a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "94e026960e01e3657300be4468c87638e205bfef2073288248fd38bf998c1a2b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d9d16e02a3f25c9259334ce3d99363dd6fcd17bfaf1f0aa069e6155f2cf5661"
    sha256 cellar: :any_skip_relocation, catalina:      "0d9d16e02a3f25c9259334ce3d99363dd6fcd17bfaf1f0aa069e6155f2cf5661"
    sha256 cellar: :any_skip_relocation, mojave:        "0d9d16e02a3f25c9259334ce3d99363dd6fcd17bfaf1f0aa069e6155f2cf5661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dfbd9cb32b30006fc840f021ac51d2c6bb93b60bbf7d09e5f65e40fb0979192"
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
