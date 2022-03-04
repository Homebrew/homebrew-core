require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.25.tgz"
  sha256 "e5e2a6f3bd6162c35342d86e29b617c3140118efcc28e5bd0fb97ff10a0d7d4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b8cba73aa051d1d1dbee3ea1e64ee3ace0b40077b333bf23bf6a735eb52d92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75b8cba73aa051d1d1dbee3ea1e64ee3ace0b40077b333bf23bf6a735eb52d92"
    sha256 cellar: :any_skip_relocation, monterey:       "9a0ddd3bd702f291bbcc7070397b39e30703e3f5f7dd93a8f7ad161296877c37"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a0ddd3bd702f291bbcc7070397b39e30703e3f5f7dd93a8f7ad161296877c37"
    sha256 cellar: :any_skip_relocation, catalina:       "9a0ddd3bd702f291bbcc7070397b39e30703e3f5f7dd93a8f7ad161296877c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f610632cdb82f5348218f4d92a9981c08ee1e473aa3c1f7b26c2634404d8aa42"
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
