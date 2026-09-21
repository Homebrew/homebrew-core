class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.85.1.tgz"
  sha256 "1f498729649bdce647d1160993b4d92bf3c614cc819213bee2f91dd34f2a7af4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "dc4bc3c921b3ba4f7fb3942966c3a08fb4c26a0e436811664533b0836a1d9966"
    sha256 cellar: :any,                 arm64_tahoe:       "32c6d3f03776b845255950fa82aef81aa0dc7984587277461434b43cebaa81f3"
    sha256 cellar: :any,                 arm64_sequoia:     "9e3b3e33dc7dac78522d7aa56017e50481e3f1b95ed2261bb116cdee78e534d6"
    sha256 cellar: :any,                 arm64_sonoma:      "82ebeb1a1d3fd649dda55196b248cd2146bc46169ba6073df43c7d338874ff28"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e90d956046cbb48c971d664268fc315dde2f0ce81269f3478e8840dfa755c2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b83e435b41ce18498eec0ba2e494013d47e731bb260c8e63bf317526ebad80d5"
  end

  depends_on "node"

  on_macos do
    depends_on "rust" => :build

    resource "clipboard" do
      url "https://registry.npmjs.org/@mariozechner/clipboard/-/clipboard-0.3.9.tgz"
      sha256 "25986ebeecaffadf3d1dd5f9199869057e4b64c37d7069c7f31c231dd86b5639"
    end
  end

  def install
    system "npm", "install", *std_npm_args
    (bin/"pi").write_env_script libexec/"bin/pi", PI_SKIP_VERSION_CHECK: "1"

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
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

    return unless OS.mac?

    # Rebuild as the npm prebuilt lacks Mach-O header space to relocate install names for bottling
    resource("clipboard").stage do
      system "cargo", "build", "--lib", "--release"
      cp "target/release/libcrosscopy_clipboard.dylib",
         node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
