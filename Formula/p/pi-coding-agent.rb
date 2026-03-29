class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.64.0.tgz"
  sha256 "492748ca1a0af4311ad2a14d2b7740b133dc3a1be1250ff0ee4955081da4a99a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f1de0bac277d85ce7ceb3f5ab365bb50d0461151343e901e2b18b1fe03f31e8"
    sha256 cellar: :any,                 arm64_sequoia: "3b620d32b94213b93cb9ba19c2d97b72b3cd756588874e08ad801874c1935e9a"
    sha256 cellar: :any,                 arm64_sonoma:  "3b620d32b94213b93cb9ba19c2d97b72b3cd756588874e08ad801874c1935e9a"
    sha256 cellar: :any,                 sonoma:        "2b6db11cb59fb27e01f29a870af2d1bd1fe2f5db91b4c7e565b264834b052aa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6fca475ad81c77e82bfaab656ecee3129b0fbadc09f850477642b72155d3c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba6114a7370c9b8802b98c74b19d082338f2fd3ec1d9a30f9417bfa6ab5c835"
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
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
