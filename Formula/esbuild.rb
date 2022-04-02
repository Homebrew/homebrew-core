require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.30.tgz"
  sha256 "7a5c17807a0f39fdc1861c345a090916c2d3a318f3e3543f3de070de82d34f0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "026486b9a24e758194b32093d999536904c618c621ccdb45dac1557371d61b17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "026486b9a24e758194b32093d999536904c618c621ccdb45dac1557371d61b17"
    sha256 cellar: :any_skip_relocation, monterey:       "ee07173fb718da93868d22a35fdca021b272c2e7c5126b4d16fcd7e73c0337a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee07173fb718da93868d22a35fdca021b272c2e7c5126b4d16fcd7e73c0337a5"
    sha256 cellar: :any_skip_relocation, catalina:       "ee07173fb718da93868d22a35fdca021b272c2e7c5126b4d16fcd7e73c0337a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91425c56e383dba5a8094e3dbd4da2405d62a6d734e6acbd6569595b6a6e456d"
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
