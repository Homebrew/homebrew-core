require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.0.tgz"
  sha256 "02f5856a8e22065927590ae708b3d00ce383144b5b88a585f6b48072240cd1a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88dbb3f68edbfc88e0f44d488b33806a8d2a4c125b6c6cf0c3d05f79e6be5b6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88dbb3f68edbfc88e0f44d488b33806a8d2a4c125b6c6cf0c3d05f79e6be5b6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88dbb3f68edbfc88e0f44d488b33806a8d2a4c125b6c6cf0c3d05f79e6be5b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "70d82280ef055729655441be4117dc068a0d41a1c41cd4d61b89749db8cb6057"
    sha256 cellar: :any_skip_relocation, monterey:       "70d82280ef055729655441be4117dc068a0d41a1c41cd4d61b89749db8cb6057"
    sha256 cellar: :any_skip_relocation, big_sur:        "70d82280ef055729655441be4117dc068a0d41a1c41cd4d61b89749db8cb6057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac5e5780c566c762099519b1e9b47faf1b5fbd0896616f9f6bab37b102c253bd"
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
