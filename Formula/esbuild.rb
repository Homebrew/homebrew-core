require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.15.tgz"
  sha256 "da0656f32a89cb9b0267cd105abea5a5d1f30c57101b2ffea5944fbc8b4534d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe1200a59567f087c8672b7d04dbfe425abcb5c9e3106afa28acbdcdf2f2d756"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe1200a59567f087c8672b7d04dbfe425abcb5c9e3106afa28acbdcdf2f2d756"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe1200a59567f087c8672b7d04dbfe425abcb5c9e3106afa28acbdcdf2f2d756"
    sha256 cellar: :any_skip_relocation, ventura:        "9db20d4c6599e0935543da4898a6367be7eebc18bf4031f539a8e2b26314521f"
    sha256 cellar: :any_skip_relocation, monterey:       "9db20d4c6599e0935543da4898a6367be7eebc18bf4031f539a8e2b26314521f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9db20d4c6599e0935543da4898a6367be7eebc18bf4031f539a8e2b26314521f"
    sha256 cellar: :any_skip_relocation, catalina:       "9db20d4c6599e0935543da4898a6367be7eebc18bf4031f539a8e2b26314521f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fac0d63cf9807336a7717e79305454cd66482a5556038c16e71ed66e096dc63"
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
