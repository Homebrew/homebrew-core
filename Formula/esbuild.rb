require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.6.tgz"
  sha256 "eeabe61b08e696a9e72412b2d9f9118729557d8e7eba837d9dc8b0e49f049b48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb959ea20ac186191482048ce71113cd41b4f5b9f0cf44f8678ef97cd5b36483"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb959ea20ac186191482048ce71113cd41b4f5b9f0cf44f8678ef97cd5b36483"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb959ea20ac186191482048ce71113cd41b4f5b9f0cf44f8678ef97cd5b36483"
    sha256 cellar: :any_skip_relocation, ventura:        "0e98469aaef7f8ec02d030e3d5a04030f4b302a868247bd271ead8dd86a86f8a"
    sha256 cellar: :any_skip_relocation, monterey:       "0e98469aaef7f8ec02d030e3d5a04030f4b302a868247bd271ead8dd86a86f8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e98469aaef7f8ec02d030e3d5a04030f4b302a868247bd271ead8dd86a86f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd3ae3c402196f583f72a950f8c0a72c19b09eb478ba26c0171c5a76fbd57843"
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
