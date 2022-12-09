require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.3.tgz"
  sha256 "30965966af5c41bf705c0ebbed34a16b737bd60cba600e0ce187b2cc8b68a0b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e29eb967b3493046fddbba76d2911d71327f611645dfb86fdd4d3c7dd4ea0350"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e29eb967b3493046fddbba76d2911d71327f611645dfb86fdd4d3c7dd4ea0350"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e29eb967b3493046fddbba76d2911d71327f611645dfb86fdd4d3c7dd4ea0350"
    sha256 cellar: :any_skip_relocation, ventura:        "d822c4f96073fbff718b971d32f12363aefceb3c937e301b99fb8c3a5ca84a7d"
    sha256 cellar: :any_skip_relocation, monterey:       "d822c4f96073fbff718b971d32f12363aefceb3c937e301b99fb8c3a5ca84a7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d822c4f96073fbff718b971d32f12363aefceb3c937e301b99fb8c3a5ca84a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda650bea345124e5bf63935216fbc882c69c9b463496fc146f092798eb5c39e"
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
