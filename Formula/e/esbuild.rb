require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.7.tgz"
  sha256 "d40b9bb667a302c9d0b359f45b15326f5315d0ac9741a111f71bd6d93705c799"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efbd95161e380a14b312819d72b32b3ed3beb4f497bfa6dda4d161666cf6b9ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efbd95161e380a14b312819d72b32b3ed3beb4f497bfa6dda4d161666cf6b9ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efbd95161e380a14b312819d72b32b3ed3beb4f497bfa6dda4d161666cf6b9ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "66540ee6049b4464ba8b0ee85a639d6e4b0909ea030577d8cd4be09df8163e60"
    sha256 cellar: :any_skip_relocation, ventura:        "66540ee6049b4464ba8b0ee85a639d6e4b0909ea030577d8cd4be09df8163e60"
    sha256 cellar: :any_skip_relocation, monterey:       "66540ee6049b4464ba8b0ee85a639d6e4b0909ea030577d8cd4be09df8163e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "507679cce2c6b2dd98a5c403967847359763d23684efc53c4f334f2c5c9fceb0"
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
