class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.61.1.tgz"
  sha256 "bea9e2dee91ce03b07d669f31090d8c1bf60f9b2252ae1cb53bd499c37068203"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78277b8b52dc5114a01ed1b9fbc5e87febcf46fa2754fc7ababc2a73d301f4ca"
    sha256 cellar: :any,                 arm64_sequoia: "b5100e5da2490c27e2ad92e444fab5f2b8fc8f2a73835bd46733e11a158c5149"
    sha256 cellar: :any,                 arm64_sonoma:  "b5100e5da2490c27e2ad92e444fab5f2b8fc8f2a73835bd46733e11a158c5149"
    sha256 cellar: :any,                 sonoma:        "63e9d8f84f4a21d95b67f4ffc8787a677549186627e73adc2642c7c7e8e68a51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9851bc4f84e7d532129adaf32f76d664ae368bb975004a4dbfe303cd22ec4744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b253bc0aaa83274f392f93f241a5735ba4a45d3d50b9071ec1d3fca98f8cc58"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mariozechner/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
