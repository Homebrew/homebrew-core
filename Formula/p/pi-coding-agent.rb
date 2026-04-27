class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.70.2.tgz"
  sha256 "6eff89a8641bd2d2145e49b807b7fcef8cbd554cf194ffc31d1abe0e360675d5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ada49b15b19f1087180aed07dfdbd973a74b2d7bc4e3e8b8c2ac5df5e66c0546"
    sha256 cellar: :any,                 arm64_sequoia: "19d2d2595fa897d38ec2cec595e71b90ad2ddb969a7c85c45af7cfa87e68ca1f"
    sha256 cellar: :any,                 arm64_sonoma:  "19d2d2595fa897d38ec2cec595e71b90ad2ddb969a7c85c45af7cfa87e68ca1f"
    sha256 cellar: :any,                 sonoma:        "ca4ba632025a7bc16a25a4573e4f1281b19fd3e308676746064236a9ec84452d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb6cc62e3dbb0681f45e19c730ddae768a99a62f535143609c318c802bc4616f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb4a3ae2aa63c5473208feb401ac2d52c8c497099b85091eeeb3e189765ed5f"
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
