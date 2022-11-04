require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.13.tgz"
  sha256 "35a1dd864b94d426c5d07288f06df7f142050893ea7937af9f016b1e48ad41a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd57bd55a1520741e0ba5af48cf52c65473715c1071e33a7bd8a32ea5da2a4c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd57bd55a1520741e0ba5af48cf52c65473715c1071e33a7bd8a32ea5da2a4c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd57bd55a1520741e0ba5af48cf52c65473715c1071e33a7bd8a32ea5da2a4c6"
    sha256 cellar: :any_skip_relocation, monterey:       "264d53da5eca3ffce0be5e0e4dc8635728afd1c6245e27676e8df9e1b8f67e7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "264d53da5eca3ffce0be5e0e4dc8635728afd1c6245e27676e8df9e1b8f67e7e"
    sha256 cellar: :any_skip_relocation, catalina:       "264d53da5eca3ffce0be5e0e4dc8635728afd1c6245e27676e8df9e1b8f67e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d13bc32ce891590af23e3f121254cf8181a819f6ae0333d0b4eae310b2fbcac2"
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
