class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.5.0.tgz"
  sha256 "5bfb66848a4c4b81c637ce8d2136be01945b70aac8e8556b091cb02241b385df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0073d0dd9c788c7d9df34c19a175b906f9dc63f72961c43e320ef3343f4c618b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0073d0dd9c788c7d9df34c19a175b906f9dc63f72961c43e320ef3343f4c618b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0073d0dd9c788c7d9df34c19a175b906f9dc63f72961c43e320ef3343f4c618b"
    sha256 cellar: :any,                 arm64_linux:       "f4c32e1f8108297ed754cc2f6dea64f9801271dbc0d4405ba4279fa57e473c69"
    sha256 cellar: :any,                 x86_64_linux:      "008174438fd28cefccdce2a49165ef482e94cf0d4cefb41b4df25a64da920fb7"
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
