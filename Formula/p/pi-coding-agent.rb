class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.5.1.tgz"
  sha256 "b213c062307356a5434880ed9d38b26c27bfab0a091fe01571c74e972af532c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66a6e7916a33b10682a668b6b291c599fe95134e5799bc64406a1523ff671e78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66a6e7916a33b10682a668b6b291c599fe95134e5799bc64406a1523ff671e78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66a6e7916a33b10682a668b6b291c599fe95134e5799bc64406a1523ff671e78"
    sha256 cellar: :any,                 arm64_linux:       "8065ffc9c599989ad69047fabc82be38c55baf4a9155065d9ccae3a18cb03e67"
    sha256 cellar: :any,                 x86_64_linux:      "6ac5479e321cb183ae3886fc27565fc6f64fbf4dd6fdaef69f42dd0134b24bb8"
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
