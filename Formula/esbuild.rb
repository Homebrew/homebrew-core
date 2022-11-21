require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.15.tgz"
  sha256 "da0656f32a89cb9b0267cd105abea5a5d1f30c57101b2ffea5944fbc8b4534d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e19dee9a57a5a9315f42db4fb1bc17c665f2313ef2a07e53a5dc8e19aff4d8cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e19dee9a57a5a9315f42db4fb1bc17c665f2313ef2a07e53a5dc8e19aff4d8cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e19dee9a57a5a9315f42db4fb1bc17c665f2313ef2a07e53a5dc8e19aff4d8cb"
    sha256 cellar: :any_skip_relocation, ventura:        "51493eb43341513106c3a65a393cc879c87aaa5c2130625281f93518d29b64fc"
    sha256 cellar: :any_skip_relocation, monterey:       "51493eb43341513106c3a65a393cc879c87aaa5c2130625281f93518d29b64fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "51493eb43341513106c3a65a393cc879c87aaa5c2130625281f93518d29b64fc"
    sha256 cellar: :any_skip_relocation, catalina:       "51493eb43341513106c3a65a393cc879c87aaa5c2130625281f93518d29b64fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7012e014708c81fd13e243f40f02e6623a06e1093a6d7c3b03a2dffca0b3e80a"
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
