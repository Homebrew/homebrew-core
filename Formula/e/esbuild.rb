class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.27.4.tar.gz"
  sha256 "30f63c28fd5e14aa0c2878012a23cd2a2ed4c6e152fa309bc11a3429b1f49497"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9b4e5c601768b0bb5d3c528d2bdd4e678db2bce5eec65beaec2e9b4f4559b16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9b4e5c601768b0bb5d3c528d2bdd4e678db2bce5eec65beaec2e9b4f4559b16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9b4e5c601768b0bb5d3c528d2bdd4e678db2bce5eec65beaec2e9b4f4559b16"
    sha256 cellar: :any_skip_relocation, sonoma:        "8538361af21bd175720fdb8f5926dd391c8928bff346d9d5fcd5883479f76a19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0b8820be229d3b1e3a611039896c6176616824ae4972d9e61c1c9b09386a90f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3404dc0f06311c10a94c5e9f249388d6f7cc2133e6966248ac8bea69097f4506"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/esbuild"
  end

  test do
    (testpath/"app.jsx").write <<~JS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
      process.exit()
    JS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
