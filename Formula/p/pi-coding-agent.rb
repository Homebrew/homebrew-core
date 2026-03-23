class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.62.0.tgz"
  sha256 "60e07c4a7cab63e8a066dab4397244df7ec0971371b8ffbf45b624b7a3b30d30"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21b6a795e89c1e9dbb4e045e9116f64c3cca8b58f8ba16635ccd1136c78d611a"
    sha256 cellar: :any,                 arm64_sequoia: "86a131eeb583c5813915cc8703f127e10565912ad0f3492f5dcb3c812c98d9ec"
    sha256 cellar: :any,                 arm64_sonoma:  "86a131eeb583c5813915cc8703f127e10565912ad0f3492f5dcb3c812c98d9ec"
    sha256 cellar: :any,                 sonoma:        "d04a7c724e9c2d23cf4920e1f92733ce8694a652a8b049b04cff726e1b9859b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "576536841e34cf07cc4ebba4a6a1b71099a8796990f113060d81be9a97d7ff5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f1f6a7021a952061bb5857948a77a1aa1e67e1c348f8bab90356c38033dbae"
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
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
