class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.25.4.tar.gz"
  sha256 "4661a2b1d2b1db035a19eca5e771a40b6c16b23279aae02022def9fa45ed5ad9"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdd37229ff118962d2d8092b36c18af0e72a5cb8ab824dfe90fdecbb8b8ce5e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdd37229ff118962d2d8092b36c18af0e72a5cb8ab824dfe90fdecbb8b8ce5e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdd37229ff118962d2d8092b36c18af0e72a5cb8ab824dfe90fdecbb8b8ce5e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a322a64d412c13933430679569cfb5d623d05c19ab266d13205cb975fe0ebbc"
    sha256 cellar: :any_skip_relocation, ventura:       "7a322a64d412c13933430679569cfb5d623d05c19ab266d13205cb975fe0ebbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42bc8c07e1ed3ec052f691012c14c8fc13bc4a5c2439d5fbbe09de7bc1da9e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1fd9dfe035aa0dad5f65db9f9509d32d42dece05dabaef7deb639b9f5bee247"
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
