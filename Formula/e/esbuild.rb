require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.21.1.tgz"
  sha256 "e18d2e1cc4c690ab4e1d9274214195c69e021f5b0f08c0762151b602795bd9e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32dc47afd7a2ef61869a71763bde47cf4593961062e822a51432a57853ec08ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef01a5539ee7c63b9fc3f816ff0fb7fa0f4d1e4f86dac6b7118e511e1939eb02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e7f39955640ee90de3510aa215c015512e41c0283a387bdcac2dbe304a1c1f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "788f9871eb2b26417efa4e0b48823265dbbb53a2dab1c99a3b2c2d6cb5eb90bd"
    sha256 cellar: :any_skip_relocation, ventura:        "166902a64528f290d219522680939ea38e10ca579eeaeaedbb95dbdf9cf978ad"
    sha256 cellar: :any_skip_relocation, monterey:       "18d8d227d1cf6e56b9ebe96f49b3c95902559437feed40c8b068f560de133765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6747b1958b5ab8d7a6799e7e656f2e93b1fa41aa66b0775e8cc50783e155e066"
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
