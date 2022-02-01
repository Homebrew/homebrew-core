require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.16.tgz"
  sha256 "43cbc7c4c2729b764e67e8be11dfa1aa4859d30da2ca9b3f8cd02d5d67044ff8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f9b2c42a10da7b221cac941e9ae0847f4cd51b49f6fb46fe5e3ab4e130672a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f9b2c42a10da7b221cac941e9ae0847f4cd51b49f6fb46fe5e3ab4e130672a3"
    sha256 cellar: :any_skip_relocation, monterey:       "f5b58b05043b31d841a66085485525b61b83e129f4462a71cdf8810208f0c3e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5b58b05043b31d841a66085485525b61b83e129f4462a71cdf8810208f0c3e9"
    sha256 cellar: :any_skip_relocation, catalina:       "f5b58b05043b31d841a66085485525b61b83e129f4462a71cdf8810208f0c3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7264d836f57cda309bbbc84717ea3196474cb94720b0828de9152a4ddd0956c2"
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
