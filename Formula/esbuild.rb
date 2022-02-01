require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.16.tgz"
  sha256 "43cbc7c4c2729b764e67e8be11dfa1aa4859d30da2ca9b3f8cd02d5d67044ff8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbcbb6d47ee31a614461e9eb68727b53ca3f36d2b8248cb8bc71571971134d70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbcbb6d47ee31a614461e9eb68727b53ca3f36d2b8248cb8bc71571971134d70"
    sha256 cellar: :any_skip_relocation, monterey:       "ac3d40dc0a332a566b80e9087940509e4b188becbd67bb79525ff007da117bcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac3d40dc0a332a566b80e9087940509e4b188becbd67bb79525ff007da117bcf"
    sha256 cellar: :any_skip_relocation, catalina:       "ac3d40dc0a332a566b80e9087940509e4b188becbd67bb79525ff007da117bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71fcf2fd8e0b4850220e5046935bde99f272c9570d8334fcfca1284735ca929a"
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
