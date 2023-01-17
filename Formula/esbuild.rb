require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.1.tgz"
  sha256 "fdc552f1f5366b3b4b1611a1f334e1024739a2a0260ac8f49a4b88afd8a38347"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9e0f3b889002f36e94e22e417853c2b937efb4bfc60c0739750b788fb6202bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9e0f3b889002f36e94e22e417853c2b937efb4bfc60c0739750b788fb6202bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9e0f3b889002f36e94e22e417853c2b937efb4bfc60c0739750b788fb6202bc"
    sha256 cellar: :any_skip_relocation, ventura:        "28f98be07fa0d506700bb8e62bfbc9aeae10ba4ec6f06235f562847783a5f306"
    sha256 cellar: :any_skip_relocation, monterey:       "28f98be07fa0d506700bb8e62bfbc9aeae10ba4ec6f06235f562847783a5f306"
    sha256 cellar: :any_skip_relocation, big_sur:        "28f98be07fa0d506700bb8e62bfbc9aeae10ba4ec6f06235f562847783a5f306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc4952ee9ca2dfbe57938b508ae76d9d394692a8ca64f119162a37b2cd11b97"
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
