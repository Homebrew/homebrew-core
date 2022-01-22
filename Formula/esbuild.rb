require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.13.tgz"
  sha256 "20d56d84306b819c18dc9d85859c0f346d4f28218c328e09c12d0b89e6a84771"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "874faf4bcbf08ce77b596699741507d85ff19028a557f0340f1f7770dc40a473"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "874faf4bcbf08ce77b596699741507d85ff19028a557f0340f1f7770dc40a473"
    sha256 cellar: :any_skip_relocation, monterey:       "55d010737b2a2281d0e9f8a109faa1ca477db169c200f4ab80a377634dc59d86"
    sha256 cellar: :any_skip_relocation, big_sur:        "55d010737b2a2281d0e9f8a109faa1ca477db169c200f4ab80a377634dc59d86"
    sha256 cellar: :any_skip_relocation, catalina:       "55d010737b2a2281d0e9f8a109faa1ca477db169c200f4ab80a377634dc59d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85e125608e993d53082c50a77b53fae836a006352c3639e9cfd89be721402129"
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
