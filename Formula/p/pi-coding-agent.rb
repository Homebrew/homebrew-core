class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.66.1.tgz"
  sha256 "34ddba0371107ede41872bb9dc998d10277592090d3cfb1ee81b039f019bcf21"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c47eedb1c3a80dc6a4813adbd0c5ef9b3815052265f584f81caa36873f5f69e3"
    sha256 cellar: :any,                 arm64_sequoia: "c3818939762dfae479f845c9b2fcdd788c797f86a18770b996f5a7a25a4bb907"
    sha256 cellar: :any,                 arm64_sonoma:  "c3818939762dfae479f845c9b2fcdd788c797f86a18770b996f5a7a25a4bb907"
    sha256 cellar: :any,                 sonoma:        "c93ce82d669b0f38a615a85080e2fa589ed43a5e8bd17e94a9debc973e0fdbfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ab7546a0d87ada932474a3590142efd818c6afc1d526170e51f77fa32bfc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b79b963ee5e4d612bd17b16acf4a8c6d7675c812e279b2a563efc8b57c6409"
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
