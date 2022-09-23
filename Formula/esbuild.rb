require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.9.tgz"
  sha256 "a313d59e0bec262f72599df11af62ef40fdf3e7d7fd5fbbb356b9e7e09594e9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "365f4a3f81dd4e340dc9529446b74930d6e30fcb0808009539c9c66115092c3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "365f4a3f81dd4e340dc9529446b74930d6e30fcb0808009539c9c66115092c3a"
    sha256 cellar: :any_skip_relocation, monterey:       "3838370828230cdc5d9643a83cffd6b592bbc5ec1fdf7107d28d5ce0f7f03c1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3838370828230cdc5d9643a83cffd6b592bbc5ec1fdf7107d28d5ce0f7f03c1e"
    sha256 cellar: :any_skip_relocation, catalina:       "3838370828230cdc5d9643a83cffd6b592bbc5ec1fdf7107d28d5ce0f7f03c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd10d1b9034df1fbf8313cd64af46daa0619495d2665d9daa283befda6bdad25"
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
