class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.61.0.tgz"
  sha256 "2efbffbc1cf06225c1100dbf33b21ff8a3cad1e90dc99525994ee66599d31607"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b53301a7be527af97ca7c196d361baf99bec460c0eca173461333fd774209407"
    sha256 cellar: :any,                 arm64_sequoia: "eb922ce011476af8d12043fda86ffdf438be95d9d1314a7b77428ed3c0be00d9"
    sha256 cellar: :any,                 arm64_sonoma:  "eb922ce011476af8d12043fda86ffdf438be95d9d1314a7b77428ed3c0be00d9"
    sha256 cellar: :any,                 sonoma:        "9e8568cf67833afe0acf4ba0385928314d9ee098b079b68261dcf5e80e959e5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f37b8907dd8fd471ba12fb8b89fa5b06dbb92a48c9ce7810641683ab5e20fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09de4f76ce21b85be007f632143ee5338f8d8b0e4b0a6b4375ad96866abbc723"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mariozechner/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
