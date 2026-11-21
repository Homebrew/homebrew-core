class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.6.0.tgz"
  sha256 "85d5de404e019e850c90ee9ac6dc6c16240da122fdce0314895608164030336b"
  license "MIT"

  bottle do
    manifest_sha256 "126327c969789d88bea2d9d378e091f036da0fc3e7c2ecdba18ad33282adff10"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f096b1dcf4507a511fb27531c60ca0743cdc807f446fec5b54a3e5b1b513d7df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f096b1dcf4507a511fb27531c60ca0743cdc807f446fec5b54a3e5b1b513d7df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f096b1dcf4507a511fb27531c60ca0743cdc807f446fec5b54a3e5b1b513d7df"
    sha256 cellar: :any,                 arm64_linux:       "de379a8593251d7ce5bf68e894840cd2c1bd8c0cb497b816bba1aa55136ac0f4"
    sha256 cellar: :any,                 x86_64_linux:      "ca23a90e0f624fe3d4293bfaa78b56a2a1d0ab182e39136f623b24135829e222"
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
