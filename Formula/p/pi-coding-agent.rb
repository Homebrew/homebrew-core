class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.78.1.tgz"
  sha256 "ef69821c383d92fd27e7d9adbdcb1e37621441e94c52348e47a2901ea9d7dd0c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ef6f43683494b117b3308f787a1776411aa7a32fb5e1af111c8c481a8caa52d"
    sha256 cellar: :any,                 arm64_sequoia: "be18bc4121dfa54d48c840119492256130e6ec241e25bb1ac7066fe78bbbae96"
    sha256 cellar: :any,                 arm64_sonoma:  "be18bc4121dfa54d48c840119492256130e6ec241e25bb1ac7066fe78bbbae96"
    sha256 cellar: :any,                 sonoma:        "d30376cd6de859625fb7f1295e282c48d24bdb067f91c601ba741670e18a2e97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6171889ada1d52ec7e66e3299491f02f309ca670a68684ae971e5fd1d8312eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ea62d6100fc793d67f4a2d68db137556dcb06172ff7c614a973054d36178375"
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

    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
