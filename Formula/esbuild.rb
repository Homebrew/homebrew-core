require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.22.tgz"
  sha256 "08a0a47252e6902ef53984a94146d5f4dfdb67e7cf111f4e4b400c6951881f59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b5f08d1bc1d41abd0e6b5046ee2d7904734e16fd4150d08f6cdc9c969d8a684"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b5f08d1bc1d41abd0e6b5046ee2d7904734e16fd4150d08f6cdc9c969d8a684"
    sha256 cellar: :any_skip_relocation, monterey:       "4048d68087dc2ab316afb605cc47d5aeb748b69331b3cf01bc66aceb487d27e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4048d68087dc2ab316afb605cc47d5aeb748b69331b3cf01bc66aceb487d27e8"
    sha256 cellar: :any_skip_relocation, catalina:       "4048d68087dc2ab316afb605cc47d5aeb748b69331b3cf01bc66aceb487d27e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b131f949d1302347e3262237a853c87ca59510a0bd21c2f3a13c1e42deed8c82"
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
