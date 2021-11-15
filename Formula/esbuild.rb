require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.13.tgz"
  sha256 "45acf6a4803ffa13f2b937b8dd1cf50866c38c48dd4949e24a8b6d492a5de626"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a18e38326d6329f56abf7b4efddae4fb633f6defa1579fa1b6d16946b274514"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a18e38326d6329f56abf7b4efddae4fb633f6defa1579fa1b6d16946b274514"
    sha256 cellar: :any_skip_relocation, monterey:       "63d40536d6cde2d0dc7ae359d787362a194dbbe34fe96843776519aba55f7fe5"
    sha256 cellar: :any_skip_relocation, big_sur:        "63d40536d6cde2d0dc7ae359d787362a194dbbe34fe96843776519aba55f7fe5"
    sha256 cellar: :any_skip_relocation, catalina:       "63d40536d6cde2d0dc7ae359d787362a194dbbe34fe96843776519aba55f7fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2103c5d0a7c57e1996cd95480cc9a915493cdba6c888afc9f4142a203022a4b"
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
