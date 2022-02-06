require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.19.tgz"
  sha256 "1a2e1c47b32698c1ab2a4ef9a2458f12ae05a5f2463e55db74e20929c8a43047"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d493d07164fc66c909f9354dc7e90c52fcf03cf9730bb8517f489d89aaed715"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d493d07164fc66c909f9354dc7e90c52fcf03cf9730bb8517f489d89aaed715"
    sha256 cellar: :any_skip_relocation, monterey:       "3d5e8efe5df95fe559ae3345afc618286ff9971921904cd13d39609b511eb40f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d5e8efe5df95fe559ae3345afc618286ff9971921904cd13d39609b511eb40f"
    sha256 cellar: :any_skip_relocation, catalina:       "3d5e8efe5df95fe559ae3345afc618286ff9971921904cd13d39609b511eb40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e82d1280252e7acdd6ab118f8d8c09e08c2b1afa4d2424d8ce2c0a856667c522"
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
