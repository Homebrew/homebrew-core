require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.30.tgz"
  sha256 "7a5c17807a0f39fdc1861c345a090916c2d3a318f3e3543f3de070de82d34f0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccaf9107efeff6b93e865ea12685bed79f5e62ea3816d84ab0d2f20009093161"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccaf9107efeff6b93e865ea12685bed79f5e62ea3816d84ab0d2f20009093161"
    sha256 cellar: :any_skip_relocation, monterey:       "d626a2ee5ff57dc8527db225127ae3e12ccc74733bd7428cb91bc8edf482d659"
    sha256 cellar: :any_skip_relocation, big_sur:        "d626a2ee5ff57dc8527db225127ae3e12ccc74733bd7428cb91bc8edf482d659"
    sha256 cellar: :any_skip_relocation, catalina:       "d626a2ee5ff57dc8527db225127ae3e12ccc74733bd7428cb91bc8edf482d659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ed03769be1d9c660a6fe7d9bd8538c3bf20e1ff5dfccff23c9c3f7088564098"
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
