class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.6.1.tgz"
  sha256 "e3b0eb54b6e1e95b60ec7c4204959bd69adc51fb1f0da3a59430bbc9a593734f"
  license "MIT"

  bottle do
    manifest_sha256 "e5724b0a85df83dfa7230c933ea2b0147cd16bf1c120b8216fe60690f720efcf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3767fa3006e79c75c4cefe17810a3fb651647143e569dcc03e49ed1513eb464"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3767fa3006e79c75c4cefe17810a3fb651647143e569dcc03e49ed1513eb464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b3767fa3006e79c75c4cefe17810a3fb651647143e569dcc03e49ed1513eb464"
    sha256 cellar: :any,                 arm64_linux:       "4877d332528fce79f54585d8659ae8d8bfae243e8a56bed5f0555aa2f7763cd3"
    sha256 cellar: :any,                 x86_64_linux:      "1faef07720b67d298451e20d15b5d4e9d81add2f7d8faed26785f188cd8ccce9"
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
