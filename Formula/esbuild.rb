require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.12.28.tgz"
  sha256 "4ae1134dfb04be9cd562557d81badc37b7127b16b9f9034dcf5a876bfef17dcf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f96aca5cb3925677886cde7c1a034b54119a93757fe528ac707dacdf6d9f9f7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "749f61f05017cce73accd1aef1aa19479a2382d4edd6552177d2acc9969566bd"
    sha256 cellar: :any_skip_relocation, catalina:      "749f61f05017cce73accd1aef1aa19479a2382d4edd6552177d2acc9969566bd"
    sha256 cellar: :any_skip_relocation, mojave:        "749f61f05017cce73accd1aef1aa19479a2382d4edd6552177d2acc9969566bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc0a8787ec1c56ba42c2556f0220223c4215d9bbe24d0b8313e3ef309e7df861"
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
