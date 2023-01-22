require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.4.tgz"
  sha256 "97be435f91045c1b917af41151149b71234329181458087c15f3712b87e7e0b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c8b0ff61abc573f35ac164720973a6c76a54198ffbffe867f172396f16b98e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c8b0ff61abc573f35ac164720973a6c76a54198ffbffe867f172396f16b98e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c8b0ff61abc573f35ac164720973a6c76a54198ffbffe867f172396f16b98e2"
    sha256 cellar: :any_skip_relocation, ventura:        "f5f1fcdf5f12ce28922cb2447b82d0a550a3e22f846e69870cc97c9e9ad88657"
    sha256 cellar: :any_skip_relocation, monterey:       "f5f1fcdf5f12ce28922cb2447b82d0a550a3e22f846e69870cc97c9e9ad88657"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5f1fcdf5f12ce28922cb2447b82d0a550a3e22f846e69870cc97c9e9ad88657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce1318491bae63595f1a78e639530ccfc151dbc8cc22c0710a9561274255e2f"
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
