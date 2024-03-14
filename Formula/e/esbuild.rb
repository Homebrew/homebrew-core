require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.20.2.tgz"
  sha256 "3b193b5835cdd518ad6b2f35f207fa3e913e1bac37c82c7fcf0b82c1d3a862f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11040fdfb4574e2cc451c7f12d6460a6e85f7bac71e2244bff3704b63591e66d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11040fdfb4574e2cc451c7f12d6460a6e85f7bac71e2244bff3704b63591e66d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11040fdfb4574e2cc451c7f12d6460a6e85f7bac71e2244bff3704b63591e66d"
    sha256 cellar: :any_skip_relocation, sonoma:         "24167e39436189691d01792a16b32250abd00eec9963e5d47b647d59a235c029"
    sha256 cellar: :any_skip_relocation, ventura:        "24167e39436189691d01792a16b32250abd00eec9963e5d47b647d59a235c029"
    sha256 cellar: :any_skip_relocation, monterey:       "24167e39436189691d01792a16b32250abd00eec9963e5d47b647d59a235c029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576a0fa0aeb7db893a40744a218cf506f0fca8382a0ff7595f2c33dea3698888"
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
