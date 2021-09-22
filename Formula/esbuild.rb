require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.12.29.tgz"
  sha256 "54be1a1abc8ad0b887fec28cdc1b759231c70336fd31fca471df8944e16fef75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a730265a6c376a8e8c4ce3f385a3bda6c885afad07aec579ef54af4c109f741c"
    sha256 cellar: :any_skip_relocation, big_sur:       "518623b06184620a88f60cb6caad4ca1ff96b9f4289e8cb96670a8ffeacf187d"
    sha256 cellar: :any_skip_relocation, catalina:      "518623b06184620a88f60cb6caad4ca1ff96b9f4289e8cb96670a8ffeacf187d"
    sha256 cellar: :any_skip_relocation, mojave:        "518623b06184620a88f60cb6caad4ca1ff96b9f4289e8cb96670a8ffeacf187d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ce7898f24abbc8c57819f2791ba4d10015e886be231781c0750823928f05a7d"
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
