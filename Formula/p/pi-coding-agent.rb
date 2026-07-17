class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.80.10.tgz"
  sha256 "9f2771711b8d4ebb8d59e3177026ab417bfc6caf0d4296a58de741b41e4d9c1c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29725d7ce30ca66aa86e88f5d2a829b4face13d553d1c6a0f3f4027a5e9f3bf5"
    sha256 cellar: :any,                 arm64_sequoia: "c68d305b3a5ebedb7b581e823d55fe4f6163c476652a187ac43c38ac82eec1a1"
    sha256 cellar: :any,                 arm64_sonoma:  "c68d305b3a5ebedb7b581e823d55fe4f6163c476652a187ac43c38ac82eec1a1"
    sha256 cellar: :any,                 sonoma:        "c4842558678ae37d55e55c357dcc0dd5aa30425ad6d246ec7c42c7a68166c185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9edbe2d5ff8bc5781540bedb1c656f09b8ab35fac769160153f658d03b01024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32516c02f57d5f241b9e00d6a4baa0f467be44fb13c11397d26b1176d428e5bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    (bin/"pi").write_env_script libexec/"bin/pi", PI_SKIP_VERSION_CHECK: 1

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
