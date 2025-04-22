class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "01a6c0a5949e5c2d53e19be52aec152b3186f8bbcf98df6996a20a972a78c330"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa954cd31cbdf0a86ef49421374c322ac7b156f8878bd655a4a5cdf4cb3a95a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa954cd31cbdf0a86ef49421374c322ac7b156f8878bd655a4a5cdf4cb3a95a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa954cd31cbdf0a86ef49421374c322ac7b156f8878bd655a4a5cdf4cb3a95a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d277f162bfb6ce259997123258e0171cdcf43f36fd7e1b8b23b4fb658e82001b"
    sha256 cellar: :any_skip_relocation, ventura:       "d277f162bfb6ce259997123258e0171cdcf43f36fd7e1b8b23b4fb658e82001b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a527b37feb65d4f7e22f786d153f771382766e1187a1110919a3917cc91a0ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5551e49a4e2790f317c401ce940fee0c79cb5fa761515ca5bd4d67a5891e25a1"
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
