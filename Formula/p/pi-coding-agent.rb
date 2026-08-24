class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.84.2.tgz"
  sha256 "95b899cd7b1a0c1f0174c7bf33ab427435e3553a7d1f4756661aa9c7f1a68ffa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dce82f2ec851e66927d2e20375767b88f2b66e7c50765f25a939eb7715909ea8"
    sha256 cellar: :any,                 arm64_sequoia: "38f0c5104f9e8b9ed968a4bcac412b6eb67c62208b17f2ad9f18a520149d0698"
    sha256 cellar: :any,                 arm64_sonoma:  "8c2bc87fe9db6e20894be6a95e59edbb72eccc8617f4286afb5f27446b76fab5"
    sha256 cellar: :any,                 sonoma:        "549c7c76474d27b6b01635792da4cffce994a7ec54ecb9005390b152e7b800d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12c1633cc8641146b95080a80ac73ba50b39e97add80de8a2305e0e5991c6316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a20b65211ec1576c231345fd6da4a52291038e738b98a4508d80a19b95aa1e"
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
    (bin/"pi").write_env_script libexec/"bin/pi", PI_SKIP_VERSION_CHECK: 1

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
