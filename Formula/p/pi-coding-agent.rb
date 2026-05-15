class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.74.0.tgz"
  sha256 "974a73b96195bd7d630e115869ecb5e0dd7a5c3a38ee4926dc99448663d4a344"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a6c6d7ff207303db83576118a0601b95d4b79340b00c9cc2905579f5721a47f"
    sha256 cellar: :any,                 arm64_sequoia: "b71b3804c4b329b9e72fbe59d701ab869daf322bb9d0c1ad9f3d3e304de95361"
    sha256 cellar: :any,                 arm64_sonoma:  "b71b3804c4b329b9e72fbe59d701ab869daf322bb9d0c1ad9f3d3e304de95361"
    sha256 cellar: :any,                 sonoma:        "dbd11d2589609551a2fb947b236a533e75dd1f29a1f4ba5d8a9e1e7552162797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a6953882879a4571d0027bed9fa8e4ece9f3788b34bc59c462c1977f41c4dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6274af319ddeac12f98e5be6cb2f9c16046525a063c1b0940469b1b25a2a238a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
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
