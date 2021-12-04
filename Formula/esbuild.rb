require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.2.tgz"
  sha256 "6c47da3bd83045b673333d8c39eb1cc7756069a2316af35713c25220d5ae7e47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83a73f58b31842ff0adb5eaf22e26b61c71be3fcfccbb5d51db958ef7b693d17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83a73f58b31842ff0adb5eaf22e26b61c71be3fcfccbb5d51db958ef7b693d17"
    sha256 cellar: :any_skip_relocation, monterey:       "9f254db0d1173190d68962c3de402a3af1d4698584d9c9da57602a955edf20f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f254db0d1173190d68962c3de402a3af1d4698584d9c9da57602a955edf20f6"
    sha256 cellar: :any_skip_relocation, catalina:       "9f254db0d1173190d68962c3de402a3af1d4698584d9c9da57602a955edf20f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a708aea47a1bc3111221fb6b2804dc918f1f6e676cd6f4e96b980c2b7168d872"
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
