class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.67.5.tgz"
  sha256 "69f5c32cffa030d2e90556b6fa4cb1b0acb354355bca2a8e0d4de1269faf4f88"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f434e6fbfb2fd43cb061306b547bcebe0fbece2fadd6c75631e1eb34efba07c3"
    sha256 cellar: :any,                 arm64_sequoia: "bed8657b6a2f9081938b397093b6f6fc5541cc9159312ee7a60e7561c16eaee8"
    sha256 cellar: :any,                 arm64_sonoma:  "bed8657b6a2f9081938b397093b6f6fc5541cc9159312ee7a60e7561c16eaee8"
    sha256 cellar: :any,                 sonoma:        "b1bac1ab5efb9ad553d0e758b3fb73fffa6019e9fa3de9894956dc97b0fbfbb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1a7cd23653c473c6040fba3d06d0bb3e43859911764cbe0debdef002548185b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a23ef0fe9c7377340ba1d99caff0ec5f578c8be71e89e70a5ec6be7f6a5371ca"
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
