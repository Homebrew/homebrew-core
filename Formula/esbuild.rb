require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.28.tgz"
  sha256 "ec1e8d5f6e78970fb521fde9ceebf7ab1ef0b92a74722db468e92d5b262b0c73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d63b6deb963aa622f49c93167de60b31768d6c88d4a089dd94cde7197cabb157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d63b6deb963aa622f49c93167de60b31768d6c88d4a089dd94cde7197cabb157"
    sha256 cellar: :any_skip_relocation, monterey:       "e90022ef6947258fe7e8efec1b8af77c7aea9d65aa9c95da301875cb6b015aaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "e90022ef6947258fe7e8efec1b8af77c7aea9d65aa9c95da301875cb6b015aaa"
    sha256 cellar: :any_skip_relocation, catalina:       "e90022ef6947258fe7e8efec1b8af77c7aea9d65aa9c95da301875cb6b015aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1588fe1380f0c93d30686dcaa1a2fcb1b98f0a9587ca4bff05e748e7775b726b"
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
