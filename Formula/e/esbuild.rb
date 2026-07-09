class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "65c756fa87d43178ac4a5242454c2bd0fde325f8ecf77997f8fa4b88f94d5cd2"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c932cde078c5cfbbaa0a2f6c3b9270259b024cb9012d8ad45ad056a99be9c317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c932cde078c5cfbbaa0a2f6c3b9270259b024cb9012d8ad45ad056a99be9c317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c932cde078c5cfbbaa0a2f6c3b9270259b024cb9012d8ad45ad056a99be9c317"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f1d8b2ca99e7f3b4328ebd01c75c1c058db6dd5a4478393442a7720a285b6ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a5e7f7d4fb56ffd13e9c9d7de8db2cb886693499e5b7966416853bbf03ec53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44623c37f82c3d4df6bd5762fb7c10b2922d3b550b20f5a87b39cb079aeed5cc"
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
