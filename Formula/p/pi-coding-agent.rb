class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.5.2.tgz"
  sha256 "691bde186273b457d9d1c41d0fd47b57853b5e85ded1add1a1f6b78e66c261f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad68468fc268c6f97637b495fc408434a59a6e21fdc59acde6177f7945ea5e2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad68468fc268c6f97637b495fc408434a59a6e21fdc59acde6177f7945ea5e2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad68468fc268c6f97637b495fc408434a59a6e21fdc59acde6177f7945ea5e2e"
    sha256 cellar: :any,                 arm64_linux:       "0fc95fc3050cc015ff424a98658bb032231fc9dc4a09de401f289f84282e53cb"
    sha256 cellar: :any,                 x86_64_linux:      "ef032ce971162ba59dfed7b761f9608947a97c85877b718e3314d50e2e595a79"
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
