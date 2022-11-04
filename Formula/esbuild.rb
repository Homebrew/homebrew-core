require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.13.tgz"
  sha256 "35a1dd864b94d426c5d07288f06df7f142050893ea7937af9f016b1e48ad41a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "765dc9e2df898409e7581a074a50b4f1b15ddab6049ff8ea0dfc8fd4222c4e06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "765dc9e2df898409e7581a074a50b4f1b15ddab6049ff8ea0dfc8fd4222c4e06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "765dc9e2df898409e7581a074a50b4f1b15ddab6049ff8ea0dfc8fd4222c4e06"
    sha256 cellar: :any_skip_relocation, monterey:       "ad1e072fd3354914335b3fc4c27cc75430c938515d76f7dec2770d87836473c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad1e072fd3354914335b3fc4c27cc75430c938515d76f7dec2770d87836473c1"
    sha256 cellar: :any_skip_relocation, catalina:       "ad1e072fd3354914335b3fc4c27cc75430c938515d76f7dec2770d87836473c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40a4a9d8144f91e856a49f221f16e0f5193c89b78871b2e4199cfebac3ad5373"
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
