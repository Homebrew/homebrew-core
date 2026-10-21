class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.3.0.tgz"
  sha256 "ae2785e870b81a8c8e1d44510a57b5ee0bfc9e974679ac2faaada4aabee3d3c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4756f2e83ae6e56b7bab907ef6cf360e0cc9c416d082fe3a6bd230fba11c4010"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4756f2e83ae6e56b7bab907ef6cf360e0cc9c416d082fe3a6bd230fba11c4010"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4756f2e83ae6e56b7bab907ef6cf360e0cc9c416d082fe3a6bd230fba11c4010"
    sha256 cellar: :any,                 arm64_linux:       "f87f33c37910e654d786d9180c6e71366a62e6fc79bb2a32bd2b3a87515b7b18"
    sha256 cellar: :any,                 x86_64_linux:      "803c9f00ba594082a8f7da2b2a1c997d503f3451f99cac929d4240eef8ada106"
  end

  depends_on "node"

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "npm", "install", *std_npm_args
    (bin/"pi").write_env_script libexec/"bin/pi", PI_SKIP_VERSION_CHECK: "1"

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end

    # Rebuild the X11 clipboard helper against our `libxcb`
    system "bash", node_modules/"@earendil-works/pi-tui/native/linux/build.sh" if OS.linux?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
