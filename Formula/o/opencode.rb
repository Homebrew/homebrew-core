class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.16.2.tgz"
  sha256 "18b8181a9fd814df4bf1aaf09ff6d51572c945770e5f71ef21fcf1abc64fa6d7"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "d9d03f39e73c458b5277dfe7af9be1502bd179b0a7cef91f7c14eae8f907d64d"
    sha256                               arm64_sequoia: "d9d03f39e73c458b5277dfe7af9be1502bd179b0a7cef91f7c14eae8f907d64d"
    sha256                               arm64_sonoma:  "d9d03f39e73c458b5277dfe7af9be1502bd179b0a7cef91f7c14eae8f907d64d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d8ab334a268261654479733652b24fbff9f00a53810f18816aa4cabb821be70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fabcb286e323f80774057b31bf565438b5f0327a06c8059af7cd3a4acd9dd5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d7a7bc8f0beaf97be7d9e26e4b57692de27dd8cc601b6be27ff831090603b7"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
