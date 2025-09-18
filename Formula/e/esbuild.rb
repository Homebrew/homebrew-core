class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.25.10.tar.gz"
  sha256 "2080a7e6bf4a8deed3f33d15a8fd8a689a3af74cc2c1e782e546c54c3c9b92f2"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9eda8248958196b824974d71dc06e7250482bdfbe2e3738f55199c68ea51fc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9eda8248958196b824974d71dc06e7250482bdfbe2e3738f55199c68ea51fc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9eda8248958196b824974d71dc06e7250482bdfbe2e3738f55199c68ea51fc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "68d229f7caa6704ef83f7d7760b5f2e11c081500e419fe14f7c74194283fb72f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f63297ab2a8bfa3302c4c3900d7e5950cee2c886d0e48e721dd6c566ac67c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27808df63a2207bfe40677bae327e2fa33631cdb7f3fa67806516bc7b9756631"
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
