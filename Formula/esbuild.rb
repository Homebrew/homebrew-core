require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.19.tgz"
  sha256 "e8ec25d33814a3808d71a4c7ae37b7a9eccf2919a179e23a6ed5a49637b3fc10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aee0744fb8fbc39f931b79771f283b78f2ae9b764a154bda0d9f484bd4816fc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aee0744fb8fbc39f931b79771f283b78f2ae9b764a154bda0d9f484bd4816fc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aee0744fb8fbc39f931b79771f283b78f2ae9b764a154bda0d9f484bd4816fc9"
    sha256 cellar: :any_skip_relocation, ventura:        "9df13019511befd827ed911055de5dbd3aabc8431b713feb45e9c13002de7635"
    sha256 cellar: :any_skip_relocation, monterey:       "9df13019511befd827ed911055de5dbd3aabc8431b713feb45e9c13002de7635"
    sha256 cellar: :any_skip_relocation, big_sur:        "9df13019511befd827ed911055de5dbd3aabc8431b713feb45e9c13002de7635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2cc55517397eecf797166c35107abb6ece2ef2cc5e48a687c9355ff321cb56a"
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
