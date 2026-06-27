class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.80.2.tgz"
  sha256 "9cab186615345f3cc2ab1d35f7d6f139306a3122a030a45f7c245489f7349085"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "058516ac5bd98ed95ca25838bc0f12c23422cfa5585003207cd1a3027143b9cc"
    sha256 cellar: :any,                 arm64_sequoia: "12b1964c54c5ad38fa96441f386b4a3b56ff9695118a9dac9669c3c7390b00fd"
    sha256 cellar: :any,                 arm64_sonoma:  "12b1964c54c5ad38fa96441f386b4a3b56ff9695118a9dac9669c3c7390b00fd"
    sha256 cellar: :any,                 sonoma:        "adbced3f70cb2bc7a793270748e11d0ac62a323ac8fe990feb878553f53012d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bca0783e21c9e32c3dda3f15c5aa2639bd62e5dec5957bbd5db4ae1aa4540d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091accaef0125acfe3e056c5db692036b5b076812ee11db3c6de756bad669fcf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end

    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
