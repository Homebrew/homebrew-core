class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.81.1.tgz"
  sha256 "420113c0282160e6181656fd16cf18742f76bf9040ee3dfb9cb67e3e6ad5641c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a01c4adbc02e887f1f2f7e554e565f7b2c3e892e1697304985ced7b98cb8b64c"
    sha256 cellar: :any,                 arm64_sequoia: "8f48034d6d498074a9f9b50fa52fb35ede9a066f99e41792014e0ba96f9c418f"
    sha256 cellar: :any,                 arm64_sonoma:  "caed1bf45223e898b7ef31c9bde28dd47df1d156e309c15acd2e3fa32c783b9a"
    sha256 cellar: :any,                 sonoma:        "67261a2ff0ff20bb9f745f66d3aff755dce78cbe9a4233a2d8ff5954da266e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "195dc77e0264e626603f754c801defa91378322242f0e51b2a1913a33b530ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "472414d70e181b7cf136c2044b67efb6ab303525cdfedd0ac2a32dd2ec666cde"
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
