require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.42.tgz"
  sha256 "083f8e98cf3a1ae0471c5e556c6dd12804062d32f72ff7d964343d6559a41df5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a74ee071a396c6d0264ecfde31b48bbfd8a2cfd547be9e965699706fa446d61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a74ee071a396c6d0264ecfde31b48bbfd8a2cfd547be9e965699706fa446d61"
    sha256 cellar: :any_skip_relocation, monterey:       "4434e326b9cbacffe3d0af9a375d154fc5d14c052de6c911fb68604ed32bacdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4434e326b9cbacffe3d0af9a375d154fc5d14c052de6c911fb68604ed32bacdf"
    sha256 cellar: :any_skip_relocation, catalina:       "4434e326b9cbacffe3d0af9a375d154fc5d14c052de6c911fb68604ed32bacdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdf57ab980a3b6693d4ca921069b664e77e66b8a7fca53f8aaa85a5b3dd435a0"
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
