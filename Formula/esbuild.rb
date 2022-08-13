require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.1.tgz"
  sha256 "6109ae6fa0ff1917b90ae77f96bfa3b85e5502c7024b3d64c68b7d79270cf479"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d3e3ed25fec3a62dd8a59e51cb3d1f0795016c5797df535aebfd8f901a4ba04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d3e3ed25fec3a62dd8a59e51cb3d1f0795016c5797df535aebfd8f901a4ba04"
    sha256 cellar: :any_skip_relocation, monterey:       "c56478a900d0109b3eff9fa210e72c9b7079387d54a508d8a85c9140cda7fb40"
    sha256 cellar: :any_skip_relocation, big_sur:        "c56478a900d0109b3eff9fa210e72c9b7079387d54a508d8a85c9140cda7fb40"
    sha256 cellar: :any_skip_relocation, catalina:       "c56478a900d0109b3eff9fa210e72c9b7079387d54a508d8a85c9140cda7fb40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a5cf4880d2b72e881c4a62c01bdc9aaed4635340a0a91a1bd5a46c2ed1f05ea"
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
