class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "0a5a5ae446be2dd1cacc7040abead328e11ba2d880396c823be453bb08097af0"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31b0e5ec3a91a735ece731fb53251fee8da319837aa473410834222a102ec3bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31b0e5ec3a91a735ece731fb53251fee8da319837aa473410834222a102ec3bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31b0e5ec3a91a735ece731fb53251fee8da319837aa473410834222a102ec3bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "359db80c28d01ef31d60aecbd54498757f7664826ad03c4c1eab2b357fd23aa6"
    sha256 cellar: :any_skip_relocation, ventura:       "359db80c28d01ef31d60aecbd54498757f7664826ad03c4c1eab2b357fd23aa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe40c257b3aaffc799faa6847ca0ab0dd90f6cba8db61fb563a7a6f91a3d546f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8022b1c1c6b76801e98c1fdcc932ce11da94cbac68409c65c40f1eda98adb7a7"
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
