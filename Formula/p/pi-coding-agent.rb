class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.80.3.tgz"
  sha256 "155c5800134cb8df6c47adb3eab56415e8fa7746e0b1cba6687134137c451d90"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f3a63a9d39399d077bd8bd91698e5159b316a1150c3d10a53eb2286381217e29"
    sha256 cellar: :any,                 arm64_sequoia: "984a352add5795c2d570b5a9ad38381a9242196c9007d75cd4def55318174877"
    sha256 cellar: :any,                 arm64_sonoma:  "984a352add5795c2d570b5a9ad38381a9242196c9007d75cd4def55318174877"
    sha256 cellar: :any,                 sonoma:        "a8c7464a42cbb7f976013be71d0acaa484f1f77ffc311aaf7086bc7d02536f82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb9586e4eb8adaa041b5dcb07a9cfae4339808aff96bc15892cc9902685e27d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "974fd566ab12fbb885aaf58962fc8964c7d5b948a1967dab59770c9d22054e0c"
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
