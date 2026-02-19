class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.27.3.tar.gz"
  sha256 "05d56070104b46d24c8921bfc4c83209d71cf583eb0396c13d0f359705bb5b61"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a95668be4a38d020c2abafa9697c336d1593dfc2e58223036d9f1a04b3bb9926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a95668be4a38d020c2abafa9697c336d1593dfc2e58223036d9f1a04b3bb9926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a95668be4a38d020c2abafa9697c336d1593dfc2e58223036d9f1a04b3bb9926"
    sha256 cellar: :any_skip_relocation, sonoma:        "016acef2dee0cff19a79d6280675b37dcddc3126029280312fab8c347a42d919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "178a4dee01d76ec8844744719c36e5d06213fd3716ffc7bfa81dead47ea88c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "085a0b97746153c6de5bf7e972808e436b0e3fa70c92ec06967ac2dd735cc539"
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
