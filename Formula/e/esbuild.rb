class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "300162f899361d9f0263065f8728ef9086dcfc1a3d36bcbc4e0abe5de9c58bf8"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b55d4276e7c10d94911322ea9c975662a08c5e22b1700b23679aa92209078435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b55d4276e7c10d94911322ea9c975662a08c5e22b1700b23679aa92209078435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b55d4276e7c10d94911322ea9c975662a08c5e22b1700b23679aa92209078435"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d54444a8283d249c49cbbc0ff5b695091afd4f59ed2743ab2dcb9a29ba45b6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01fc550f3526f66955830d6a82301d2c05f731aa8fbfeef13dc9dc77fb6359db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71a74fea9f03878c9f9246cba75ab8fe71e4902ac71a1194403bbba18bdfab37"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args, "./cmd/esbuild"
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
