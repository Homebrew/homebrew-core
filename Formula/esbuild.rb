require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.3.tgz"
  sha256 "da5ed75590a694b28901a3af8a761f6a1e90feac77cf2d758dc36d8a89db3a02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d6ff9e5548e0e85380504eaafa0464421ef24aab33b5edac9fa3fe0e4096ac6"
    sha256 cellar: :any_skip_relocation, big_sur:       "912fca551e6a8b47b0136f8a41497e2a2f579ddb0bdbc1597c50c22711bf2e47"
    sha256 cellar: :any_skip_relocation, catalina:      "912fca551e6a8b47b0136f8a41497e2a2f579ddb0bdbc1597c50c22711bf2e47"
    sha256 cellar: :any_skip_relocation, mojave:        "912fca551e6a8b47b0136f8a41497e2a2f579ddb0bdbc1597c50c22711bf2e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5692314c57b15968cf16c0f8d30e661b5b264e8e5036d9ca94ef9c07273eef0"
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
