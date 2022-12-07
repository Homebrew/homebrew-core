require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.1.tgz"
  sha256 "40a5e3025b3356e2dd3f9b1127af850bac58028aba45eeadad5d6affb51b771d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cea310abd75490403e8592130ed305aee0141a0c45a87e28fbdbaafbfd8fb83e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cea310abd75490403e8592130ed305aee0141a0c45a87e28fbdbaafbfd8fb83e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cea310abd75490403e8592130ed305aee0141a0c45a87e28fbdbaafbfd8fb83e"
    sha256 cellar: :any_skip_relocation, ventura:        "dc1f6a485dcf7dd104b7137776ea762bb902135eedf2f677d79ae688e814f94a"
    sha256 cellar: :any_skip_relocation, monterey:       "dc1f6a485dcf7dd104b7137776ea762bb902135eedf2f677d79ae688e814f94a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc1f6a485dcf7dd104b7137776ea762bb902135eedf2f677d79ae688e814f94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a08e9b98b2cc43fcf6e73f854fab89de6bfb9071321410b051c89e66495754"
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
