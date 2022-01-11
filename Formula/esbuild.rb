require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.11.tgz"
  sha256 "8bf5b090eb72329d29c09c22fae5b078880b0e6e0c8361400add145c7fe2374f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ef01f4dd76d4380902121da63d428a12fa82e28e03386cfb11420eaddb83d04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ef01f4dd76d4380902121da63d428a12fa82e28e03386cfb11420eaddb83d04"
    sha256 cellar: :any_skip_relocation, monterey:       "efe7a9ff7082861ce18e37d639b1a8070ad3cbe02c05dcb2e1a8f897d03d24fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "efe7a9ff7082861ce18e37d639b1a8070ad3cbe02c05dcb2e1a8f897d03d24fb"
    sha256 cellar: :any_skip_relocation, catalina:       "efe7a9ff7082861ce18e37d639b1a8070ad3cbe02c05dcb2e1a8f897d03d24fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee534408b9eba3080d6021977c620177d8ea97950750e6d0b52a3dd52d11d2cf"
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
