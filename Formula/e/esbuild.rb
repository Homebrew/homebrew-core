require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.3.tgz"
  sha256 "c2feb85d245ba2cd27c94a615e586a54d266cbb6907160c8bcb4fbb2b95372c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d22d8a90039a81cc8ea73e4a276d471c5ac14172c02ab0066d98cfdb048ba5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d22d8a90039a81cc8ea73e4a276d471c5ac14172c02ab0066d98cfdb048ba5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d22d8a90039a81cc8ea73e4a276d471c5ac14172c02ab0066d98cfdb048ba5e"
    sha256 cellar: :any_skip_relocation, ventura:        "8932dc69678cf0fc5e365ea1dccd35764b5bb20243aaaf41c359b4464f4764cd"
    sha256 cellar: :any_skip_relocation, monterey:       "8932dc69678cf0fc5e365ea1dccd35764b5bb20243aaaf41c359b4464f4764cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "8932dc69678cf0fc5e365ea1dccd35764b5bb20243aaaf41c359b4464f4764cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa630e3c085d3147f1f09b3579f95dd924b8574a191541f523e4926c03f5eca"
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
