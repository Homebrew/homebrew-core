require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.3.tgz"
  sha256 "85c91a88019881c25d48ec68428a15f8e11e42d19b14048ce8e29672630337f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5cfbd0659cd4fe1a4a9b792e4c454ec24e2e840203756f12d364bd9fbc9ccbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5cfbd0659cd4fe1a4a9b792e4c454ec24e2e840203756f12d364bd9fbc9ccbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5cfbd0659cd4fe1a4a9b792e4c454ec24e2e840203756f12d364bd9fbc9ccbe"
    sha256 cellar: :any_skip_relocation, ventura:        "429291738a3f66e7c5e0d3abfd1ad3f920890fc5aa27b47290b3e59d367750bf"
    sha256 cellar: :any_skip_relocation, monterey:       "429291738a3f66e7c5e0d3abfd1ad3f920890fc5aa27b47290b3e59d367750bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "429291738a3f66e7c5e0d3abfd1ad3f920890fc5aa27b47290b3e59d367750bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f38199dea7bbab139812ff60aa4c5784b579dee3a0bdcf84c6b53f6e82316af"
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
