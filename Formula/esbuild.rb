require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.5.tgz"
  sha256 "abdac63602c326d697ada6d4472eb85b5b6cd29d816b24895091f87faf7f2aba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c22d564114678960f194ad9235363efd1227456846504951ec4baeab4900aa27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c22d564114678960f194ad9235363efd1227456846504951ec4baeab4900aa27"
    sha256 cellar: :any_skip_relocation, monterey:       "24dc6c8fdf8285885f884795638ff6f6bc20bf188c7a3bced2fa8d1f5791037d"
    sha256 cellar: :any_skip_relocation, big_sur:        "24dc6c8fdf8285885f884795638ff6f6bc20bf188c7a3bced2fa8d1f5791037d"
    sha256 cellar: :any_skip_relocation, catalina:       "24dc6c8fdf8285885f884795638ff6f6bc20bf188c7a3bced2fa8d1f5791037d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f9f7bae8d55de86a239a581237e22ef2626baa21ee864464d1f741868e783c1"
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
