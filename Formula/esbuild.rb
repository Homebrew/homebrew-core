require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.44.tgz"
  sha256 "34333f9746c74375d059b0403ae4bc0c458b6854a92a3c679c554f682b3fa834"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ab27158a5afeabc3ae953bda7f78f0982dfdfb670715749888c61680642ff9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34ab27158a5afeabc3ae953bda7f78f0982dfdfb670715749888c61680642ff9"
    sha256 cellar: :any_skip_relocation, monterey:       "b55c1138a98a2bf5018421078626fab82571aef1405f2e0163e294845420d22e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b55c1138a98a2bf5018421078626fab82571aef1405f2e0163e294845420d22e"
    sha256 cellar: :any_skip_relocation, catalina:       "b55c1138a98a2bf5018421078626fab82571aef1405f2e0163e294845420d22e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "973996868118271ce6c6cfaeab17b13b39d00d295f880917bb92d9a5a040a7e2"
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
