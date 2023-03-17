require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.12.tgz"
  sha256 "8b842cacd4961af9a83ddf241464c436b46d147d9a5b69678d4fb05b4721766b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9db3e5232bbaec3d2217d99fb62fde2599e4be8132267deee032e9475618cb02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9db3e5232bbaec3d2217d99fb62fde2599e4be8132267deee032e9475618cb02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9db3e5232bbaec3d2217d99fb62fde2599e4be8132267deee032e9475618cb02"
    sha256 cellar: :any_skip_relocation, ventura:        "38a37c11efdb5a0a1eeab2ef84ea218bed3e94e74aa68a36f9cba4652a51d583"
    sha256 cellar: :any_skip_relocation, monterey:       "38a37c11efdb5a0a1eeab2ef84ea218bed3e94e74aa68a36f9cba4652a51d583"
    sha256 cellar: :any_skip_relocation, big_sur:        "38a37c11efdb5a0a1eeab2ef84ea218bed3e94e74aa68a36f9cba4652a51d583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6593acd1ea9d61164358e656496f74700a8d5508d1e0da4f4b83e96f65f62f09"
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
