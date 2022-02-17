require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.22.tgz"
  sha256 "08a0a47252e6902ef53984a94146d5f4dfdb67e7cf111f4e4b400c6951881f59"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9631adba27b74693f5440d98b12f5bc0d758dea6f92196a4ad65f3606daea252"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9631adba27b74693f5440d98b12f5bc0d758dea6f92196a4ad65f3606daea252"
    sha256 cellar: :any_skip_relocation, monterey:       "367b61867b51e6ff604d950c75c0369da30ee57977a3d912612ca069d08140a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "367b61867b51e6ff604d950c75c0369da30ee57977a3d912612ca069d08140a2"
    sha256 cellar: :any_skip_relocation, catalina:       "367b61867b51e6ff604d950c75c0369da30ee57977a3d912612ca069d08140a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4705a6e6df54401e582620b4a6f7b7fbed53a77b3eeadf46651003537df859b"
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
