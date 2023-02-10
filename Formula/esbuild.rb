require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.7.tgz"
  sha256 "3fac1e7cc878193aa1b426754187da569e30502a21ec79aecd7df0d194ffa73b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d792385324ae1dda0f8eb7374a381a60cb831a657171ec8fa216f3c14f93f35b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d792385324ae1dda0f8eb7374a381a60cb831a657171ec8fa216f3c14f93f35b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d792385324ae1dda0f8eb7374a381a60cb831a657171ec8fa216f3c14f93f35b"
    sha256 cellar: :any_skip_relocation, ventura:        "123ef5fea0322ed9fcf5dd5cc57b97a3747d92c968aa5ad7fa62407f94450784"
    sha256 cellar: :any_skip_relocation, monterey:       "123ef5fea0322ed9fcf5dd5cc57b97a3747d92c968aa5ad7fa62407f94450784"
    sha256 cellar: :any_skip_relocation, big_sur:        "123ef5fea0322ed9fcf5dd5cc57b97a3747d92c968aa5ad7fa62407f94450784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "413c487c55b6e73344ba5eb0ef280b89427e17012b7648aa40958fc855ddf514"
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
