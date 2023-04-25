require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.18.tgz"
  sha256 "3f767793f1e64bed0feee1f8383697d8b65b2a66ec3fb79859560fc0d4aa1502"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2feb42fe5d4af5eb5541bfa51d41b7885d4cf524e6598807fc697c86ff0a7b05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2feb42fe5d4af5eb5541bfa51d41b7885d4cf524e6598807fc697c86ff0a7b05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2feb42fe5d4af5eb5541bfa51d41b7885d4cf524e6598807fc697c86ff0a7b05"
    sha256 cellar: :any_skip_relocation, ventura:        "4bd25c9d986438e422884537e42d2bab1989152b343ffe970b2f32b33e8ea03f"
    sha256 cellar: :any_skip_relocation, monterey:       "4bd25c9d986438e422884537e42d2bab1989152b343ffe970b2f32b33e8ea03f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bd25c9d986438e422884537e42d2bab1989152b343ffe970b2f32b33e8ea03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "097285799ebc84ef6ad707b16eb0e4f739d8659702b1b9b2bf5b585ddee516bd"
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
