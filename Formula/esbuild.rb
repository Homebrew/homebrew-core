require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.14.tgz"
  sha256 "5693b32dd979ad221f24cec7046fed365af78c02917a4bf78c9d495238b043ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d99ac31e09cf65c4347ad4de88538de737d997ebcf2c8bdee0aaabd42edef42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d99ac31e09cf65c4347ad4de88538de737d997ebcf2c8bdee0aaabd42edef42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d99ac31e09cf65c4347ad4de88538de737d997ebcf2c8bdee0aaabd42edef42"
    sha256 cellar: :any_skip_relocation, ventura:        "3324c7f6a2a412cdf5241b46f8351ce73fe1d6a93d5b5810a333f853d83dbb62"
    sha256 cellar: :any_skip_relocation, monterey:       "3324c7f6a2a412cdf5241b46f8351ce73fe1d6a93d5b5810a333f853d83dbb62"
    sha256 cellar: :any_skip_relocation, big_sur:        "3324c7f6a2a412cdf5241b46f8351ce73fe1d6a93d5b5810a333f853d83dbb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87582bf3c0ad4513fe9714bd37e14132e3192b0a3d6654f015943d0318c5751c"
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
