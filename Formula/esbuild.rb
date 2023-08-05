require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.18.tgz"
  sha256 "b3743d34028f672f81fb37ef192384e33a797f7394d77cb2d8db40fb525de826"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a67994ca1febe2b22077bda1555122e8c9f82710b8ec4f2466632d8d7472fab5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a67994ca1febe2b22077bda1555122e8c9f82710b8ec4f2466632d8d7472fab5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a67994ca1febe2b22077bda1555122e8c9f82710b8ec4f2466632d8d7472fab5"
    sha256 cellar: :any_skip_relocation, ventura:        "3ee2205c3cf73eb88bb803456b1a12625ba4b4738c4c17a7f77baf8c6157d796"
    sha256 cellar: :any_skip_relocation, monterey:       "3ee2205c3cf73eb88bb803456b1a12625ba4b4738c4c17a7f77baf8c6157d796"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ee2205c3cf73eb88bb803456b1a12625ba4b4738c4c17a7f77baf8c6157d796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf5c2b1e63214f82f7f6470234e5e46d620254770ed0afba16ed7b4aabc27075"
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
